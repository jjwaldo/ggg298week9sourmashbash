NUMBER=['1',
        '2',
        '3',
        '4',
        '5']

rule all:
    input:
        "all.cmp.matrix.png"

rule download_data:
   # input:expand("https://osf.io/{name}/download", name=GENOMEFILES)
    output:
        expand("{name}.fa.gz", name=NUMBER)
    shell:
        """wget https://osf.io/t5bu6/download -O 1.fa.gz
           wget https://osf.io/ztqx3/download -O 2.fa.gz
           wget https://osf.io/w4ber/download -O 3.fa.gz
           wget https://osf.io/dnyzp/download -O 4.fa.gz
           wget https://osf.io/ajvqk/download -O 5.fa.gz"""

rule sourmash_compute:
    input: 
        expand("{name}.fa.gz", name=NUMBER)
    output:
        expand("{name}.fa.gz.sig", name=NUMBER)
    conda:
        "envs/sour.yml"
    shell:
        """sourmash compute -k 31 1.fa.gz
           sourmash compute -k 31 2.fa.gz
           sourmash compute -k 31 3.fa.gz
           sourmash compute -k 31 4.fa.gz
           sourmash compute -k 31 5.fa.gz"""

rule sourmash_compare:
    input:
        expand("{name}.fa.gz.sig", name=NUMBER)
    output:
        "all.cmp"
    conda:
        "envs/sour.yml"
    shell:
        "sourmash compare {input}.sig -o all.cmp"

rule sourmash_plot:
    input:
        "all.cmp"
    output:
        "all.cmp.matrix.png"
    conda:
        "envs/sour.yml"    
    shell:
        "sourmash plot --labels all.cmp"    
