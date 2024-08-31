using CSV, DataFrames

#=
Rejecting -Inf for two reasons:
1: It screws up the maths (-Inf + AnythingElse = -Inf)
2: It means either the elapsed time or the gz source code is measured to be 0, meaning insufficient precision
=#
function mean(c)
	v = [i for i in c if i > -Inf]
	return sum(v)/length(v)
end

function std(c)
	v = [i for i in c if i > -Inf]
	dv = v .- mean(v)
	variance = mean(dv.^2)
	return variance^0.5
end

const datasource = "./alldata.csv"
const datasink = "./results/"

alldata = DataFrame(CSV.File(datasource, select=[:name, :lang, :n, :var"elapsed(s)",:var"size(B)"]))
alldata[:, :logproduct] = log.(alldata.var"elapsed(s)" .* alldata.var"size(B)") #"logproduct" is the quantity of interest
alldata = alldata[:, Not(:var"size(B)", :var"elapsed(s)")]


for problem in unique(alldata.name)
	problemdata = filter(:name => ==(problem), alldata)[:, Not(:name)]
	max_n = maximum(problemdata.n) #Largest problems are likely to most closely represent long-running programs
	lpd = filter(:n => ==(max_n), problemdata)[:, Not(:n)]
	
	lpd_gdf = groupby(lpd, :lang)
	problemranking = combine(lpd_gdf, :logproduct => mean, :logproduct => std)
	sort!(problemranking, [:logproduct_mean])
	
	filepath = datasink * problem
	CSV.write(filepath, problemranking)
end
