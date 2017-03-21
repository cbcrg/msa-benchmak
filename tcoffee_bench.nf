import groovy.text.*
import java.io.*


params.aligners = "$baseDir/aligners.txt"
params.scores="$baseDir/scores.txt"
params.output_dir = ("$baseDir/output")
params.datasets_directory="$baseDir/benchmark_datasets"
datasets_home= file(params.datasets_directory)
params.score="bengen/baliscore"
params.bucket="100"

//Reads which aligners to use
boxes = file(params.aligners).readLines().findAll { it.size()>0 }


//Reads which score to use
//boxes_score = file(params.scores).readLines().findAll { it.size()>0 }

boxes_score=["$params.score"]
/*
 * Creates a channel emitting a triple for each file in the datase composed
 * by the following element:
 *
 * -Name of the dataset (e.g. Balibase,Oxfam..)
 * -Name of the file (e.g. B11001_RV11 )
 * -the file itself
 *
 */

dataset_fasta = Channel
            .fromPath("${params.datasets_directory}/${params.dataset}/*.fa")
            .map { tuple( it.parent.name, it.baseName, it ) }



/*
 * Execute an alignment job for each input sequence in the dataset
 */

process aln {

  tag "$method"
  publishDir "MSAs/$params.bucket/$id"

  input:
  each method from boxes
  set dataset_name, id, file(fasta) from dataset_fasta


  output:
  set method, dataset_name, id, file('aln.fa') into alignments

  """

  clustalo -i $fasta --outfmt fasta --guidetree-out the.tree --threads $task.cpus --force
  t_coffee -seq $fasta -outfile aln.fa  -dpa -dpa_tree the.tree  -dpa_method msaprobs_msa -dpa_nseq $params.bucket

  """
}



/* 
 * Evaluate the alignment score 
 */

process score {
    tag "${params.score} + $method + $dataset_name"
    publishDir "MSAs/$params.bucket/$id"
    
    input: 
    set method, dataset_name, id, file(aln) from alignments
    each score from boxes_score
    file datasets_home  
    

    output: 
    set score, method, dataset_name, id, file('score.out')  into score_output
    
    """
     msaa -r $datasets_home/${dataset_name}/${id}.fa.ref -a aln.fa > score_temp.out
     cat score_temp.out | awk '{ print "SOP="\$2";"}' >  score.out
    """
}

