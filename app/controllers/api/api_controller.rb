class Api::ApiController < ApplicationController

  respond_to :json

  before_filter :set_params, only: [:single, :lca, :pept2pro, :taxa2lca]
  before_filter :set_query, only: [:single, :lca]
  before_filter :set_sequences, only: [:single, :pept2pro]

  def set_params
    @input = params[:input]
    if @input.kind_of? Hash
      @input = @input.values
    end
    @input.map! &:chomp
    @input_order = @input.dup

    @equate_il = (!params[:equate_il].blank? && params[:equate_il] == 'true')
    @extra_info = (!params[:extra].blank? && params[:extra] == 'true')
    @names = (!params[:names].blank? && params[:names] == 'true')

    @input = @input.map {|s| s.gsub(/I/,'L') } if @equate_il
  end

  def set_query
    if @extra_info
      if @names
        @query = Taxon.includes(lineage: Lineage::ORDER_T)
      else
        @query = Taxon.includes(:lineage)
      end
    else
      @query = Taxon
    end
  end

  def set_sequences
    rel_name = @equate_il ? :peptides : :original_peptides
    @sequences = Sequence.joins(rel_name => :uniprot_entry).
      where(sequence: @input)
  end


  def messages
    version = params[:version]
    render text: "Unipept 0.4.0 is released!"
  end


  def pept2taxa
    @result = {}
    lookup = Hash.new { |h,k| h[k] = Set.new }
    ids = []
    @sequences.pluck(:sequence, :taxon_id).each do |sequence,taxon_id|
      lookup[taxon_id] << sequence
      ids.append(taxon_id)
      @result[sequence] = Set.new
    end

    ids = ids.uniq.reject(&:nil?).sort

    @query.where(id: ids).find_in_batches do |group|
      group.each do |t|
        lookup[t.id].each {|s| @result[s] << t}
      end
    end

    filter_input_order

    respond_with(@result)
  end

  def pept2lca
    @result = {}
    lookup = Hash.new { |h,k| h[k] = Set.new }
    ids = []
    @sequences = Sequence.where(sequence: @input)
    lca_field = @equate_il ? :lca_il : :lca
    @sequences.pluck(:sequence, lca_field).each do |sequence, lca_il|
      ids.append lca_il
      lookup[lca_il] << sequence
    end

    ids = ids.uniq.reject(&:nil?).sort

    @query.where(id: ids).find_in_batches do |group|
      group.each do |t|
        lookup[t.id].each { |s| @result[s] = t }
      end
    end

    filter_input_order

    respond_with(@result)
  end

  def taxa2lca
    # handle case where 1 is provided
    if @input.include? "1"
      @result = Taxon.find(1)
      @extra_info = false
    else
      lineages = Lineage.includes(Lineage::ORDER_T).where(taxon_id: @input)
      @result = Lineage.calculate_lca_taxon(lineages)
    end

    respond_with(@result)
  end

  def pept2prot
    lookup = Hash.new { |h,k| h[k] = Set.new }

    if @extra_info
      @result = Hash.new
      # Perform joins and load objects (expensive)
      ids = []
      @sequences.pluck(:sequence, "uniprot_entries.id").each do |sequence, uniprot_id|
        ids.append uniprot_id
        lookup[uniprot_id] << sequence
        @result[sequence] = Set.new
      end

      ids = ids.uniq.reject(&:nil?).sort
      UniprotEntry.includes(:name,:ec_cross_references, :go_cross_references).
        where(id: ids).find_in_batches do |group|

        group.each do |uni|
          lookup[uni.id].each {|s| @result[s] << uni}
        end
      end
    else
      @result = Hash.new { |h,k| h[k] = Set.new }
      @sequences.pluck(:sequence, "uniprot_entries.uniprot_accession_number", "uniprot_entries.taxon_id").each do |sequence, uniprot_id, taxon_id|
        @result[sequence] << [uniprot_id, taxon_id]
      end
    end

    filter_input_order

    respond_with(@result)
  end

  def filter_input_order
    @input_order.select! do |s|
      key = @equate_il ? s.gsub(/I/,'L') : s
      @result.has_key? key
    end
  end

end
