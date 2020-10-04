
def sort(data,order=0)
  data_with_index = data.map.with_index{|n,i| [n,i]}
  if (order == 0)
    sorted_data = data_with_index.sort do |a,b|
      r = a[0] <=> b[0]
      (r == 0)? a[1] <=> b[1] : r
    end
  else
    sorted_data = data_with_index.sort do |a,b|
      r = b[0] <=> a[0]
      (r == 0)? a[1] <=> b[1] : r
    end
  end
  sorted_data.map{|a| a[0]}
end

