#!/bin/bash


#转换.csv文件的格式
file_name="HLA_A0101_data/HLA_A0101_ionslist.csv"
echo -e "peptide\tmodification\tcharge" > "HLA_A0101_data/HLA_A0101_peptide.txt"
while read line
do
i=0
j=0
while true
do

c="${line:$i:1}"
if [ "$c" = "/" ]
then
        break
elif [ "$c" = "[" ]
then
        ((j++))
elif [ "$c" = "]" ]
then
        ((j--))
elif [ $j -eq 0 ]
then
        echo -e "$c\c" >> "HLA_A0101_data/HLA_A0101_peptide.txt"
fi

((i++))
done

((i++))
echo -e "\t\t${line:$i:$((${#line}-$i))}" >> "HLA_A0101_data/HLA_A0101_peptide.txt"

done < $file_name



#使用pDeep2进行预测，-e 0.27 设定相对碰撞能量为0.27（可以根据情况调整）
python pDeep-master/pDeep2/predict.py -e 0.27 -i QE -in HLA_A0101_data/HLA_A0101_peptide.txt -out HLA_A0101_data/HLA_A0101_predict.txt



#调整文件格式，得到.mgf文件
file_name="HLA_A0101_data/HLA_A0101_predict.txt"
echo -e "\c" > HLA_A0101_data/HLA_A0101_predict.mgf
while read line
do
	if [ "${line:0:6}" = "TITLE=" ] || [ "${line:0:8}" = "pepinfo=" ]
	then
		x=`expr index "$line" "||"`
		line="${line:0:$((x-1))}/${line:$((x+1)):$((${#line}-x-1))}"
	fi

	if [ "${line:0:6}" = "TITLE=" ]
	then
		line="NAME=${line:6:$((${#line}-6))}"
	fi
	echo "$line" >> HLA_A0101_data/HLA_A0101_predict.mgf
done < $file_name


#调用R语言程序，将.mgf转换成.msp
Rscript Mgf2msp.r HLA_A0101_data/HLA_A0101_predict.mgf $PWD

#修改格式，使文件能够被spectrast处理
file_name="HLA_A0101_data/HLA_A0101_predict.msp"
echo -e "\c" > HLA_A0101_data/HLA_A0101_Predict.msp
while read line
do
	if [ "${line:0:10}" = "Num Peaks:" ]
	then
		line="Num peaks:${line:10:$((${#line}-10))}"
	fi
	echo $line >> HLA_A0101_data/HLA_A0101_Predict.msp
done < $file_name
rm $file_name


#使用spectrast进行搜索与建库
spectrast -cNHLA_A0101_data/raw HLA_A0101_data/HLA_A0101_Predict.msp
spectrast -sLHLA_A0101_data/raw.splib HLA_A0101_data/M20151015_HLA_A0101_1e8ceq_biorep1_techrep1.mzML
spectrast -sR -sEtxt -sLHLA_A0101_data/raw.splib HLA_A0101_data/M20151015_HLA_A0101_1e8ceq_biorep1_techrep1.mzML


#每条肽段有一个Dot值，画出Dot值的分布直方图
python draw1.py





#对于一个肽段，以离子质量为横坐标，离子相对强度为纵坐标，对于质谱实验得到的真实谱库和pDeep2预测的谱库分别画出离子分布图，比较Dot值较高的肽段的离子峰是否能够对应上，以此判断pDeep2预测的准确度
echo -e "\c" > "HLA_A0101_data/HLA_A0101_Dot.txt"
id=0
HEAD=1
while read line
do
	if [ $HEAD -eq 1 ]
	then
		HEAD=0
		continue
	fi

	i=`expr index "$line" /`
	((i+=2))
	while [ "${line:$i:1}" = " " ]
	do
		((i++))
	done

	j=$i
	while [ "${line:$j:1}" != " " ]
	do
		((j++))
	done

	Dot=${line:$i:$((j-i))}
	#忽略Dot值较小的结果（认为是噪声）
	if [ `echo "$Dot>=0.82" | bc` -eq 1 ]
	then
		((id++))

		i=0
		while [ "${line:$i:1}" != " " ]
		do
			((i++))
		done
		echo -e "$id ${line:0:$i} \c" >> "HLA_A0101_data/HLA_A0101_Dot.txt"
		sss="${line:0:$i}"

		j=`expr index "$line" /`
		i=$j
		while [ "${line:$i:1}" != " " ]
		do
			((i--))
		done
		((i++))

		while [ "${line:$j:1}" != " " ]
		do
			((j++))
		done

		echo "${line:$i:$((j-i))}" >> "HLA_A0101_data/HLA_A0101_Dot.txt"
		
		#画出分布图
		python draw2.py HLA_A0101_data/M20151015_HLA_A0101_1e8ceq_biorep1_techrep1.mgf $sss HLA_A0101_data/raw.sptxt "${line:$i:$((j-i))}" "HLA_A0101_data/ion_pictures/${id}_${Dot}.jpg" $Dot
	fi

done < "HLA_A0101_data/M20151015_HLA_A0101_1e8ceq_biorep1_techrep1.txt"

