	#!/bin/sh
#input fine p q fold_enrichment
# bash find_the_line.sh *.xls p q fold_enrichment output_file_name
USAGE()
{
	echo "USAGE: bash find_the_line.sh *.xls p q fold_enrichment output_file_name"
	exit -1
}

#input p q fold and file_name
file_name="$1"
if [[ $file_name =~ .*[.]xls ]]; then
 pvalue="$2"
 qvalue="$3"
 fold_enrichment="$4"
 output_file_name="$5"
else
 USAGE
fi

#clear output file
cat /dev/null > "$output_file_name.txt"
cat /dev/null > "seq_index.bed"

#read file line by line
while IFS=\t read -r line
do
    #ignore line start with #
    if [[ $line =~ \#.* ]]; then
        continue
    fi
    IFS=$'\t'
    arr=($line)

    #read data line
#echo "$line"
#echo "${arr[1]}"
    if [[ ${arr[1]} =~ [0-9]+ ]]; then

        #count -log10
	p_log=$(echo $pvalue | awk '{printf "%11.9f\n",-log($1)/log(10)}')
	q_log=$(echo $qvalue | awk '{printf "%11.9f\n",-log($1)/log(10)}')
	
	#find the right line
	flag=1
	
	if [ `echo "$p_log > ${arr[6]}"| bc` -eq 1 ]; then
		flag=0
	fi
	
        if [ `echo "$q_log > ${arr[8]}"| bc` -eq 1 ]; then
		flag=0
	fi

        if [ `echo "$fold_enrichment > ${arr[7]}"| bc` -eq 1 ]; then
		flag=0
	fi
	#echo "$fold_enrichment > ${arr[7]}"
	#echo "$flag"
	#output answer
	if [[ $flag -eq 1 ]]; then
		echo "$line" >> "$output_file_name.txt"
		echo -e "${arr[0]}\t${arr[1]}\t${arr[2]}" >> "seq_index.bed"
	fi
    fi
    
	
done < $file_name

