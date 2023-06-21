# ChIP-seq_Analysis-and-Spectra_Predicting
## ChIP-seq Analysis

get_bam.sh 得到.bam文件并对读入的序列进行检查

xls_processor.sh  
运行 bash xls_processor inputfile.xls p_need q_need fold_need outputfile_name
输出 outputfile_name.txt, seq_index.bed。
可根据两个文件寻找基因组中的相对位置

  MACS(Model-based analysis of ChIP-seq )，是一种能在ChIP-seq数据中识別出转录因子结合位置的算法，该算法最终给出结合位置富集峰值及统计可信度。ChIP-seq用于在全基因组范围内绘制转录因子结合位点和组蛋白修饰状态。ChIP通常在转录因子结合位点或组蛋白标记位置周围产生75-300bp的DNA片段，而高通量测序通常从ChIP DNA片段的5′端产生数千万至数亿个25-75 bp序列（称为short reads）。ChIP-seq数据分析是将short reads映射回参考基因组，short reads富集区表示转录因子结合或组蛋白标记的位点。MACS是一种从ChIP-seq数据中识别short reads富集区的计算方法，在ChIP-seq和下游分析中得到广泛应用。我们通过ChIP-seq流程生成的序列很有可能是蛋白质结合序列，有待进一步实验证明。结合的蛋白质可能是转录因子或组蛋白，需要进一步的筛选。

## 使用pDeep2预测质谱的准确度检验


HLA_A0101_process.sh 分析流程bash文件

Mgf2msp.r 将.mgf转换成.msp

draw1.py 画出Dot值分布直方图

draw2.py 画出真实谱库和pDeep2预测谱库的离子分布对比图


  pDeep2使用深度学习的方法预测蛋白质谱。本文将HLA_A0101免疫多肽的真实谱图和pDeep2预测谱图视为两个单位向量，用它们的点积来表示质谱的相似程度，检验了pDeep2预测质谱的准确度，证明其可以用于蛋白质组学研究中。蛋白质翻译后修饰（PTM）的调节对生物体起到非常重要的作用，基于串联质谱（MS/MS）自下而上的蛋白质组学是目前分析样品中PTM的主要方法。修饰肽的鉴定和修饰位点的定位依赖于理论质谱和实验质谱的比较，因此有必要开发出准确预测修饰肽MS/MS质谱的方法。pDeep2是使用迁移学习来训练的模型，我们需要检验它预测质谱的准确度，之后才能将其应用到科研中。本文运行结果表明，pDeep2能够较为准确地预测出HLA_A0101质谱的结果，因此可以在蛋白质组学的研究中用于鉴定蛋白质的翻译后修饰。
