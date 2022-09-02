# 基于Matlab的Dijkstra算法

**Dijkstra算法**:从一个节点遍历 *其余各节点的* 最短路径算法，解决的是有权图中最短路径问题。
如果仅仅只是想找到 *起点到终点* 的最短距离以及路径，那么在将终点从U集移动到S集后算法即可结束。

## 参考

1. <https://www.bilibili.com/video/BV19T4y1M7uR/?spm_id_from=333.788.recommend_more_video.0&vd_source=be5bd51fafff7d21180e251563899e5e>
2. <https://blog.csdn.net/qq_45776662/article/details/107177424>
选择特殊路径长度最短的路径，将其连接的V-S中的顶点加入到集合S中，同时更新数组dist[]。一旦S包含了所有顶点，dist[]就是从源到所有其他顶点的最短路径长度。
（1）数据结构。 设置地图的带权邻接矩阵为map[][]，即如果从源点u到顶点i有边，就令map[u][i]=<u,i>的权值，否则map[u][i]=∞；
采用一维数组dist[i]来记录从源点到i顶点的最短路径长度：采用一维数组p[i]来记录最短路径上i顶点的前驱。
（2）初始化。令集合S={u}，对于集合V-S中的所有顶点x，初始化dist[i]=map[u][i],如果源点u到顶点i有边相连，初始化p[i]=u(i的前驱是u),否则p[i]=-1
（3）找最小。在集合V-S中依照贪心策略来寻找使得dist[j]具有最小值的顶点t,即dist[t]=min，则顶点t就是集合V-S中距离源点u最近的顶点。
（4）加入S战队。将顶点t加入集合S，同时更新V-S
（5）判结束。如果集合V-S为空，算法结束，否则转6
（6）借东风。在（3）中已近找到了源点到t的最短路径，那么对集合V-S中所有与顶点t相邻的顶点j，都可以借助t走捷径。
如果dist[j]>dist[t]+map[t][j],则dist[j]=dist[t]+map[t][j]，记录顶点j的前驱为t，p[j]=t，转（3）。
————————————————
版权声明：本文为CSDN博主「wjyGrit」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_45776662/article/details/107177424
3. 《趣学算法》陈小玉 P45

## 文件说明

Dijkstra_demo.mlx 使用Matlab实时脚本演示算法。
