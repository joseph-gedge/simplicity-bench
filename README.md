The [debian benchmarks game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html) provides data relating to the performance of programs written in various languages in [this csv file](https://salsa.debian.org/benchmarksgame-team/benchmarksgame/-/blob/master/public/data/alldata.csv). While their focus is on the performance, it is interesting to note that they have recorded the compressed size of the source code.

I working with this metric:
$$
M = \ln(\text{elapsed time} \times \text{gz source code size})
$$
This metric equally penalises the elapsed time and the gz source code size. I am not interested in the maximum amount of performance it is possible to achieve; I want a measure of the performance I could easily achieve. The gz size may provide an effective proxy for this. This metric is calculated for each record in the data.

For each of the problems considered in the dataset, the largest instance of the problem is selected; there is more data relating to the largest instances, and largest instances may be more representative of long-running programs. The mean and standard deviation of $M$ are calculated for each language, and then the languages are ranked by their mean $M$.