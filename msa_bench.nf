


params.base_dir="/users/cn/mhatzou/Datasets/HomFam/seqs_noBZXU_noDuplicates/"
params.out_dir="MEGA_NF"
params.names="seatoxin hip scorptoxin cyt3 rnasemam bowman toxin ghf11 TNF sti Stap_Strp_toxin profilin ricin ghf22 ChtBD ins trfl slectin phoslip ltn il8 az kringle cryst DEATH cah mmp rub ghf10 tgfb sodcu KAS DMRL_synthase tms GEL kunitz Sulfotransfer mofe Ald_Xan_dh_2 ghf5 phc aadh annexin serpin cytb asp oxidored_q6 hpr hormone_rec hr tim glob ace cys ghf1 sodfe peroxidase uce flav HMG_box OTCace msb icd proteasome cyclo LIM HLH ldh subt int lyase_1 gpdh egf blm gluts myb_DNA-binding tRNA-synt_2b biotin_lipoyl hom ghf13 aldosered hla Rhodanese PDZ blmb rhv p450 adh aat rrm Acetyltransf sdr zf-CCHH rvp".tokenize()

Channel.from(params.names)
       .map{ tuple(it, file("${params.base_dir}/${it}_uniq.fa")) }
       .set{ file_names }

params.value=5000


process align{
  publishDir params.out_dir

  input:
      set val(name), file(seq_file) from file_names 
  output:
      file "${name}.fa" into foo
  
  
  """ 
     tea -i $seq_file -o ${name}.fa -d --cluster_size 2 --cluster_number 5000
      
  """

}
