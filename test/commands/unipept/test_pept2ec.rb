require_relative '../../../lib/commands'

module Unipept
  class UnipeptPept2ecTestCase < Unipept::TestCase
    def test_default_batch_size
      command = Cri::Command.define { name 'pept2ec' }
      pept2ec = Commands::Pept2ec.new({ host: 'http://api.unipept.ugent.be' }, [], command)
      assert_equal(1000, pept2ec.default_batch_size)
      pept2ec.options[:all] = true
      assert_equal(100, pept2ec.default_batch_size)
    end

    def test_required_fields
      command = Cri::Command.define { name 'pept2ec' }
      pept2ec = Commands::Pept2ec.new({ host: 'http://api.unipept.ugent.be' }, [], command)
      assert_equal(['peptide'], pept2ec.required_fields)
    end

    def test_argument_batch_size
      command = Cri::Command.define { name 'pept2ec' }
      pept2ec = Commands::Pept2ec.new({ host: 'http://api.unipept.ugent.be', batch: '123' }, [], command)
      assert_equal(123, pept2ec.batch_size)
    end

    def test_batch_size
      command = Cri::Command.define { name 'pept2ec' }
      pept2ec = Commands::Pept2ec.new({ host: 'http://api.unipept.ugent.be' }, [], command)
      assert_equal(1000, pept2ec.batch_size)
    end

    def test_help
      out, _err = capture_io_while do
        assert_raises SystemExit do
          Commands::Unipept.run(%w[pept2ec -h])
        end
      end
      assert(out.include?('show help for this command'))

      out, _err = capture_io_while do
        assert_raises SystemExit do
          Commands::Unipept.run(%w[pept2ec --help])
        end
      end
      assert(out.include?('show help for this command'))
    end

    def test_run
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be AALTER])
      end
      lines = out.each_line
      assert_equal('', err)
      assert(lines.next.start_with?('peptide,total_protein_count,ec_number,ec_protein_count'))
      assert(lines.next.start_with?('AALTER,1425,2.3.2.27 2.7.13.3 6.2.1.3 6.1.1.6 6.3.2.13 2.7.4.25 6.1.1.22 3.1.26.- 2.3.1.29 2.7.1.15,111 11 11 8 8 7 6 4 4 3'))
      assert_raises(StopIteration) { lines.next }
    end

    def test_run_with_fasta_multiple_batches
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be --batch 2 >test AALTER AALER >tost AALTER])
      end
      lines = out.each_line
      assert_equal('', err)
      assert(lines.next.start_with?('fasta_header,peptide,total_protein_count,ec_number,ec_protein_count'))
      assert(lines.next.start_with?('>test,AALTER,1425,2.3.2.27 2.7.13.3 6.2.1.3 6.1.1.6 6.3.2.13 2.7.4.25 6.1.1.22 3.1.26.- 2.3.1.29 2.7.1.15,111 11 11 8 8 7 6 4 4 3'))
      assert(lines.next.start_with?('>test,AALER,41797,2.3.1.9 6.1.1.16 2.7.7.38 1.3.5.1 2.7.7.7 2.1.2.10 6.3.4.2 3.1.-.- 2.3.1.16 6.3.5.3,810 608 278 155 153 125 123 122 91 86'))
      assert(lines.next.start_with?('>tost,AALTER,1425,2.3.2.27 2.7.13.3 6.2.1.3 6.1.1.6 6.3.2.13 2.7.4.25 6.1.1.22 3.1.26.- 2.3.1.29 2.7.1.15,111 11 11 8 8 7 6 4 4 3'))
      assert_raises(StopIteration) { lines.next }
    end

    def test_run_with_fasta_multiple_batches_and_select
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be --batch 2 --select ec_number >test AALTER AALER >tost AALTER])
      end
      lines = out.each_line
      assert_equal('', err)
      assert(lines.next.start_with?('fasta_header,peptide,ec_number'))
      assert(lines.next.start_with?('>test,AALTER,2.3.2.27 2.7.13.3 6.2.1.3 6.1.1.6 6.3.2.13 2.7.4.25 6.1.1.22 3.1.26.- 2.3.1.29 2.7.1.15'))
      assert(lines.next.start_with?('>test,AALER,2.3.1.9 6.1.1.16 2.7.7.38 1.3.5.1 2.7.7.7 2.1.2.10 6.3.4.2 3.1.-.- 2.3.1.16 6.3.5.3'))
      assert(lines.next.start_with?('>tost,AALTER,2.3.2.27 2.7.13.3 6.2.1.3 6.1.1.6 6.3.2.13 2.7.4.25 6.1.1.22 3.1.26.- 2.3.1.29 2.7.1.15'))
      assert_raises(StopIteration) { lines.next }
    end

    def test_run_with_fasta_multiple_batches_json
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be --batch 2 --format json >test AALTER AALER >tost AALTER])
      end
      lines = out.each_line
      assert_equal('', err)
      output = lines.to_a.join('').chomp
      assert(output.start_with?('['))
      assert(output.end_with?(']'))
      assert(!output.include?('}{'))
      assert(output.include?('fasta_header'))
    end

    def test_run_with_fasta_multiple_batches_xml
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be --batch 2 --format xml >test AALTER AALER >tost AALTER])
      end
      lines = out.each_line
      assert_equal('', err)
      output = lines.to_a.join('').chomp
      assert(output.start_with?('<results>'))
      assert(output.end_with?('</results>'))
      assert(output.include?('<fasta_header>'))
    end

    def test_run_with_empty_peptide
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be AKVYSKY])
      end
      lines = out.each_line
      assert_equal('', err)
      assert_raises(StopIteration) { lines.next }
    end

    def test_run_with_empty_and_existing_peptide
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be AKVYSKY AALTER])
      end
      lines = out.each_line
      assert_equal('', err)
      assert(lines.next.start_with?('peptide,total_protein_count,ec_number,ec_protein_count'))
      assert(lines.next.start_with?('AALTER,1425,2.3.2.27 2.7.13.3 6.2.1.3 6.1.1.6 6.3.2.13 2.7.4.25 6.1.1.22 3.1.26.- 2.3.1.29 2.7.1.15,111 11 11 8 8 7 6 4 4 3'))
      assert_raises(StopIteration) { lines.next }
    end

    def test_run_existing_peptide_no_ec_numbers
      out, err = capture_io_while do
        Commands::Unipept.run(%w[pept2ec --host http://api.unipept.ugent.be MDGTEYIIVK])
      end
      lines = out.each_line
      assert_equal('', err)
      assert(lines.next.start_with?('peptide,total_protein_count'))
      assert(lines.next.start_with?('MDGTEYIIVK,4'))
      assert_raises(StopIteration) { lines.next }
    end
  end
end
