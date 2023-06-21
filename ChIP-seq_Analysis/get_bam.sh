##序列质量检查
for sample in chip_dmel input_dmel ; do
    fastx_quality_stats -i <(gunzip -c ${sample}.fastq.gz) -o ${sample}_stats.txt
    fastq_quality_boxplot_graph.sh -i ${sample}_stats.txt -o ${sample}_quality.png -t ${sample}
    fastx_nucleotide_distribution_graph.sh -i ${sample}_stats.txt -o ${sample}_nuc.png -t ${sample}
    rm ${sample}_stats.txt
done


##原始读入计数
for sample in chip_dmel input_dmel ; do
    echo -en $sample"\t"
    gunzip -c ${sample}.fastq.gz | awk '((NR-2)%4==0){read=$1;total++;count[read]++}END{for(read in count){if(!max||count[read]>max){max=count[read];maxRead=read};if(count[read]==1){unique++}};print total,unique,unique*100/total,maxRead,count[maxRead],count[maxRead]*100/total}'
done


##读入长度检查
for sample in chip_dmel input_dmel ; do
    echo -en $sample"\t"
    gunzip -c ${sample}.fastq.gz | awk '((NR-2)%4==0){count[length($1)]++}END{for(len in count){print len}}'
    LEN=36
    gunzip -c ${sample}.fastq.gz | awk -vLEN=$LEN '{if((NR-2)%2==0){print substr($1,1,LEN)}else{print $0}}' | gzip > ${sample}_36bp.fastq.gz
done



##对读入进行匹配
for sample in chip_dmel input_dmel; do
    gunzip -c ${sample}_36bp.fastq.gz | bowtie -q -m 1 -v 3 --sam --best --strata dm5/d_melanogaster_fb5_22 - > ${sample}.sam
done

gunzip -c chip_dmel_36bp.fastq.gz | bowtie -q -m 1 -v 3 --sam --best --strata dm5/d_melanogaster_fb5_22 - > chip_dmel.sam
samtools view -Sb chip_dmel.sam > chip_dmel_nonSorted.bam
samtools sort chip_dmel_nonSorted.bam -T chip_dmel -o chip_dmel.bam

for sample in chip_dmel input_dmel; do
    samtools view -Sb ${sample}.sam > ${sample}_nonSorted.bam
    samtools sort ${sample}_nonSorted.bam -T ${sample} -o ${sample}.bam
    samtools index ${sample}.bam
    rm ${sample}.sam ${sample}_nonSorted.bam
done
