/*
 * DEFINITION OF MULTI-SAMPLE (BATCH) MODE
 */

/*
 * Include modules
 */
include { spades    } from '../modules/local/ShortReads/spades_sreads.nf'


workflow SHORTREADS_ONLY {

  take:
      input_tuple
  
  main:

  // Define default output channes
  // default must be a empty channel that
  // will be overwritten if assembler is used
  def SHORTREADS_OUTPUTS = [:]
  SHORTREADS_OUTPUTS['SPADES']    = Channel.empty()


  ch_versions_sr = Channel.empty()

  // SPAdes
  if (!params.skip_spades) {
    spades(input_tuple)
    SHORTREADS_OUTPUTS['SPADES'] = spades.out[1]
    ch_versions_sr = ch_versions_sr.mix(spades.out.versions.first())
  }

  // Gather assemblies for qc
  SHORTREADS_OUTPUTS['ALL_RESULTS'] = SHORTREADS_OUTPUTS['SPADES']
                                      .combine(input_tuple, by: 0)

  emit:
  results  = SHORTREADS_OUTPUTS['ALL_RESULTS']
  versions = ch_versions_sr

}