#!/usr/bin/env nextflow

params.base_dir="/users/cn/mhatzou/Datasets/HomFam/seqs_noBZXU_noDuplicates/"
params.out_dir="MEGA_NF"
//params.names="seatoxin hip scorptoxin cyt3 rnasemam bowman toxin ghf11 TNF sti Stap_Strp_toxin profilin ricin ghf22 ChtBD ins trfl slectin phoslip ltn il8 az kringle cryst DEATH cah mmp rub ghf10 tgfb sodcu KAS DMRL_synthase tms GEL kunitz Sulfotransfer mofe Ald_Xan_dh_2 ghf5 phc aadh annexin serpin cytb asp oxidored_q6 hpr hormone_rec hr tim glob ace cys ghf1 sodfe peroxidase uce flav HMG_box OTCace msb icd proteasome cyclo LIM HLH ldh subt int lyase_1 gpdh egf blm gluts myb_DNA-binding tRNA-synt_2b biotin_lipoyl hom ghf13 aldosered hla Rhodanese PDZ blmb rhv p450 adh aat rrm Acetyltransf sdr zf-CCHH rvp".tokenize()

params.names="blmb p450 adh aat Acetyltransf sdr zf-CCHH".tokenize()


Channel.from(params.names)
       .map{ tuple(it, file("${params.base_dir}/${it}_uniq.fa")) }
       .into{ file_names_1; file_names_2 }

params.value=5000


process mega_align{
  publishDir params.out_dir, mode: "copy"
  tag "${name}"
  errorStrategy "ignore"

  input:
      set val(name), file(seq_file) from file_names_1 
  output:
      file "${name}.fa" into foo
      set val(name), file("${name}.tree") into file_tree
  
  """ 
      tea -i $seq_file -o ${name}.fa -d --cluster_size 2 --cluster_number 5000 --tree_out  ${name}.tree > /dev/null
  """

}

/*
file_names_2
  .phase( file_tree )
  .map { files, aln -> tuple( files[0], files[1], aln[1] ) }
  .set { file_names_3; file_names_4; file_names_5 }


process clustalo_align{
  publishDir params.out_dir, mode: "copy"
  tag "${name}"
  errorStrategy "ignore"

  input:
      set val(name), file(seq_file), file(tree_file) from file_names_3
  output:
      file "${name}_CLU.fa" into foo1
  
  """
      clustalo -i $seq_file -o  ${name}_CLU.fa --guidetree-in ${tree_file} --force
  """
}



process pasta_align{
  publishDir params.out_dir, mode: "copy"
  tag "${name}"
  errorStrategy "ignore"

  input:
      set val(name), file(seq_file), file(tree_file) from file_names_4
  output:
      file "${name}_PA.fa" into foo2
  
  """
      python2.7 run_pasta.py --num-cpus ${task.cpus} -i $seq_file -d Protein -j $seq_file -o ${name}_PA.fa
  """
}



process upp_align{
  publishDir params.out_dir, mode: "copy"
  tag "${name}"
  errorStrategy "ignore"

  input:
      set val(name), file(seq_file), file(tree_file) from file_names_5
  output:
      file "${name}_UP.fa" into foo3
  
  """
      run_upp.py -s $seq_file -m amino --cpu ${task.cpus} -i $seq_file -d $seq_file -o ${name}_UP.fa
  """
}
*/