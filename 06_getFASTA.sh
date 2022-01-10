#TSS上流2kbのFASTAを作成

cd genes

bedtools getfasta -fi /Users/shigenseigyo/Desktop/reference/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed TSS_BDF1_expressed.bed -fo TSS_BDF1_expressed.fa
bedtools getfasta -fi /Users/shigenseigyo/Desktop/reference/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed allgenes_TSS.bed -fo allgenes_TSS.fa