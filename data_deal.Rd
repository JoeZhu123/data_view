system("defaults write org.R-project.R force.LANG en_US.UTF-8")
install.packages("RJSONIO")
library("RJSONIO")
#解析JSON
fromJSON()
#数据的前期处理
library(xlsx)

#读取chinaweather_city_station.xlsx中的数据，命其为c_s
setwd("/Users/joe/Documents/data_view/中国气象数据/")
c_s=read.xlsx("chinaweather_city_station.xlsx",sheetIndex=1,header=F)
names(c_s)	#列名
n=dim(c_s);n #查看数据集维度
fix(c_s)		#在列表里查看数据
#要将以上列表的city_station在中国的可视化地图上表现出来

#读取每个城市天气站点的数据做分析，需要知道每个城市天气站点的经度(longitude)，纬度(latitude)
setwd("/Users/joe/Documents/data_view/中国气象数据/chinaweather_station_observation/")
c_s_o<-read.csv("安徽_安庆_安庆 2.csv",header=T,sep=",",na.string="999999")
names(c_s_o)
n1=dim(c_s_o);n1
fix(c_s_o)
c_s_o1=c_s_o[1:4,2:6]
jpeg("安徽_安庆_安庆.jpeg")
pairs(c_s_o)
pairs(~date+temp,c_s_o)#只绘制date和temp的散点图
title(main="安徽_安庆_安庆的天气状况散点图")
dev.off()
c_s_o1=c_s_o[2,1]
fix(c_s_o1)
c_s_o1[c_s_o1==0]<-10000; #将999999这样的无效数据替换为0
#由bash file_count得出有2518个气候站点.csv文件，先分析一个站点的365*24=8760的数据
#以date为横轴，temp、rh、pop、wDir、wSpeed为纵轴画散点图，看各因子随时间的变化趋势
fix(c_s_o1)
summary(c_s_o1)
x1=c_s_o1$temp;
y1=c_s_o1$rh;
#plot(x1[1:4],y1[1:4])


#读取上海青悦环保数据,要将这些环境污染相关的数据转换成json，这种JavaScript易读的文本
setwd("/Users/joe/Documents/data_view/上海青悦环保数据/")

water_1=read.csv("国控地表水201501站点监测数据.csv",header=T)
water_2=read.csv("国控地表水监测站基础信息.csv",header=T,fileEncoding="latin1")
names(water_2);
water_2_lng=water_2[,5];
water_2_lat=water_2[,6];
water_2_da=data.frame(water_2_lng,water_2_lat);
water_2_dad=as.matrix(water_2_da);
cat(toJSON(water_2_dad));
water_2_s=toJSON(water_2_dad);
writeLines(water_2_s,"lng_lat_1.json");
fix(water_1)

air_1=read.csv("山东江苏201501空气监测数据.csv",header=T);
air_2=read.csv("山东江苏空气监测站点基础数据.csv",header=T);
names(air_2);
n1=dim(air_2);n1
air_2_lng=air_2[,6];
air_2_lat= air_2[,7];
air_2_da=data.frame(air_2_lng,air_2_lat);
air_2_dad=as.matrix(air_2_da);
cat(toJSON(air_2_dad));
air_2_s=toJSON(air_2_dad);
writeLines(air_2_s,"lng_lat_2.json");
fix(air_2);

#读取中国气象数据,要将chinaweather_grid_wind_observation相关的数据转换成json，这种JavaScript易读的文本
setwd("/Users/joe/Documents/data_view/中国气象数据/chinaweather_grid_wind_observation/")

wind_16040100=read.csv("16040100.csv",header=T,sep = " ")
names(wind_16040100);
wind_16040100_lng= wind_16040100[,0];
wind_16040100_lat= wind_16040100[,1];
wind_16040100_da=data.frame(wind_16040100_lng, wind_16040100_lat);
wind_16040100_dad=as.matrix(wind_16040100_da);
cat(toJSON(wind_16040100_dad));
wind_16040100_s=toJSON(wind_16040100_dad);
writeLines(wind_16040100_s,"wind_16040100.json");
fix(wind_16040100)