#绘制中国地图及标注其省会城市
system("defaults write org.R-project.R force.LANG en_US.UTF-8")
library(ggplot2)
ggmap(map)
library(sp)
library(gp)
library(maptools)
library(RColorBrewer)
library(plyr)
#设置参数，不设置此参数也不影响结果
str.crs<-" +proj=longlat+datum=WGS84+no_defs+ellps=WGS84+towgs84=0,0,0"
#读取中国地图的多边形数据
chinamap<-readShapePoly("/Users/joe/Documents/data_view/china/bou2_4p.shp",proj4string=CRS(str.crs))
#设置输出文件
jpeg("chinamap.jpeg")
#画地图
par(mar=c(2,2,0.1,0.1))
par(family='STKaiti')
plot(chinamap,ylim=c(18,54),panel.first=grid())
#给不同省标上不同颜色
province<-sort(unique(chinamap@data$NAME))
n<-length(province)
set.seed(1949)
color<-sample(grep("^[^(gr|bl|wh)]+",colors(),value=T),n)
for(i in 1:n){
	plot(subset(chinamap, chinamap@data$NAME==province[i]),add=TRUE,col=color[i],border="gray")
}
#添加省会城市
capital<-readShapePoints("/Users/joe/Documents/data_view/china/国家基础地理数据/res1_4m/res1_4m.shp",proj4string=CRS(str.crs))
cap.name<-iconv(capital@data$NAME,"gbk","utf8")
cap.coords<-coordinates(capital)
n<-length(cap.name)
plot(capital,add=TRUE,pch=20,cex=0.8)
pos<-rep(4,times=n)
spec.name<-c("呼和浩特","成都","西宁","太原","合肥","武汉","长沙","银川","南宁","澳门")
pos[cap.name %in% spec.name]<-2
spec.name<-c("北京","南京","上海","广州")
pos[cap.name %in% spec.name]<-3
text(cap.coords,labels=cap.name,cex=0.7,pos=pos,offset=0.2)
dev.off()

#R语言百度地图接口包绘制真实地图模型
#来自Blog:http://blog.csdn.net/trueman007/article/details/39401547
install.packages('/Users/joe/Documents/data_view/china/RbaiduMaps_0.1.tar',types='source')
library('RbaiduMaps')
#获取地址经纬度
#加载依赖的json解析包
library("RJSONIO")
getGeoCodeBD("上海东方明珠")
#函数返回经纬度地址
library(png)
mp<-GetMapBD("上海",size=c(640,640),zoom=10)
PlotOnStaticMapBD(mp)
