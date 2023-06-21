- ChIP_process的用法是-t 处理组数据文件 -c 控制组数据文件 -g 数据生物类型 -n 输出文件名

  - 处理完成后，该程序会询问需不需要后续对xls处理

    - 不需要——进程结束
    - 需要，调用执行xls_processor.sh

  - 如果出现找到paired peaks数目过少的报错，请手动使用macs3命令并添加

    ```bash
    --nomodel --extsize 147
    ```

    

- xls_processor的用法是位置参数——第一个是输入文件名，第二个是p_value最大值，第三个是q_value最大值，第四个是fold_enrichment最小值，第五个是输出txt文件名

  - 该命令生成.txt和seq_index.bed文件提供结果位点信息

  - 如果需要序列信息，使用命令

    ```bash
    bedtools getfasta -fi reference_genome_file_name.fa -bed seq_index.bed -fo output.fa
    ```

    

