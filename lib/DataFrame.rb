# DataFrame is a loose copy of the concept of the same name from the R
# statistics programming language.  Models a 2-dimensional table with 
# row and column labels.

require 'CSV'

class DataFrame
  attr_accessor :col_names, :row_names, :rows
  def initialize(csv = nil, options = {})
    @col_names = nil               # or Array, one String per column
    @rows = []                  # array of row arrays
    @row_names = []             # names from 'row_names' column, or 1..length
    @options = options

    if csv
      self.readCSV csv
    end
  end

  def _print
    cmp = proc { |a,b| a.length <=> b.length }
    nameswidth = @row_names.max(&cmp).length
    ncols = @rows[0].length
    colwidths = Array.new(ncols, 0)
    0.upto(ncols-1) do |i|
      colwidths[i] = [self[nil,i].max(&cmp).length, @col_names[i].length].max
    end
    format = "%#{nameswidth}.#{nameswidth}s " + 
      colwidths.map { |n| "%#{n}.#{n}s" }.join(" ") + "\n"
    if not @col_names.nil?
      printf(format, "", *@col_names)
    end
    0.upto(@rows.length-1) { |i| printf(format, @row_names[i], *@rows[i]) }
  end

  def readCSV(csv)
      byr = File.open(csv,'r').readline("\r")
      byn = File.open(csv,'r').readline("\n")
      if byn < byr
        sep = "\n"
      else
        sep = "\r"
      end
      wholefilearray = File.open(csv,'r').readlines(sep).map { |s| s.chomp }

      CSV::Reader.parse(wholefilearray.join("\n")) do |row|
        @rows += [ row.map { |item| item.to_s } ]
        if row.length != @rows[0].length
          raise "Bad column count at #{csv}:#{@rows.length} " +
            "(#{row.length} vs #{@rows[0].length})"
        end
      end

      # Peel off first row as header? ...
      if @options.key? 'expect_header'
        @col_names = @rows.delete_at(0)
        if @options.key? 'col_names'
          cn = @options['col_names']

          # Validate header matches our expectations
          if cn.class == Array
            if cn != @col_names
              raise "Unexpected CSV column headers for #{csv}, " +
                "wanted #{cn.join ','}, got #{@col_names}"
            end

            # Or map header names to names we want
          elsif cn.class == Hash
            uncols = 0
            @col_names = @col_names.map { |name| 
              uncols += 1
              if cn.key? name
                newname = cn[name]
                name = newname
              else
                name = "unused_column_#{uncols}"
              end
              name
            }
          else
            raise "col_names given as hash, but no header on #{csv}"
          end
        end

        # Or, if we were given col_names without expect_header, set names
      elsif @options.key? 'col_names'
        cn = @options['col_names']
        if cn.class == Array
          if cn.length != @rows[0].length
            raise "col_names has wrong element count on #{csv}" +
              "(#{cn.length} vs #{@rows[0].length})"
          else
            @col_names = cn
          end
        else
          raise "col_names has bad type on #{csv}: #{cn.class}"
        end
      end

      # Do any per-column fixups
      if @options.key? 'col_proc'
        cs = @options['col_proc']
        @rows.each do |row|
          cs.keys.each do |colname|
            proc = cs[colname]
            idx = to_col_index(colname)
            row[idx] = proc.call(row[idx])
          end
        end
      end

      # Assign row names.
      if @options.key? 'row_names'
        rn_col = @options['row_names']
        rn_col = @col_names.index(rn_col) if rn_col.class == String
        @rows.each { |row| @row_names.push row[rn_col].to_s }
      else
        @row_names = [ 1..@rows.length ]
      end
    end

  def to_col_index(value)
    if value.class == String
      strvalue = @col_names.index(value)
      return nil if strvalue.nil?
      value = strvalue
    elsif value.class != Fixnum
      raise "Index class:#{value.class} value:#{value} " +
        "isn't String or Fixnum"
    end
    return value
  end

  def [](*indices)
    raise IndexError if indices.length > 2

    # First, give trouble if a column name is asked for and required
    # but not present.
    if indices.length > 1 \
        && ! indices[1].nil? \
        && indices[1].class == String \
        && @col_names.index(indices[1]).nil? \
        && ! @require_names.nil? \
        && ! @require_names.index(indices[1]).nil?
      raise "No column named #{indices[1]}"
    end

    if indices.length == 2 && indices[0].nil? # Getting a column?
      idx = to_col_index(indices[1])
      ret = idx.nil? ? nil : @rows.map { |row| row[idx] }
    elsif indices.length < 2 || indices[1].nil? # Getting a row?
      idx = indices[0]
      if idx.class == String
        ret = @rows[@row_names.index(idx)]
      elsif idx.class == Fixnum
        ret = @rows[idx]
      else
        raise "Bad row index, Class:#{idx.class} Value:#{idx}"
      end
    else                        # Getting a cell?
      y = to_col_index(indices[1])
      ret = y.nil? ? nil : self[indices[0]][y].to_s
    end
    return ret
  end
end

