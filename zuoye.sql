
-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数  
select s.* ,b.s_score as 1score,c.s_score as 2score from student s join score b on s.s_id=b.s_id and b.c_id='01' left join score c on s.s_id=c.s_id and c.c_id='02' or c.c_id = NULL where b.s_score>c.s_score;
 

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select s.* ,b.s_score as 1score,c.s_score as 2score from student s join score b on s.s_id=b.s_id and b.c_id='01' left join score c on s.s_id=c.s_id and c.c_id='02' or c.c_id = NULL where b.s_score<c.s_score;
 
  


-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.s_id,s.s_name,ROUND(AVG(a.s_score),2) as avg_score from 
student s join score a on s.s_id = a.s_id GROUP BY s.s_id,s.s_name HAVING ROUND(AVG(a.s_score),2)>=60;
 


-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
        -- (包括有成绩的和无成绩的)
 
select s.s_id,s.s_name,ROUND(AVG(a.s_score),2) as avg_score from  student s left join score a on s.s_id = a.s_id GROUP BY s.s_id,s.s_name HAVING ROUND(AVG(a.s_score),2)<60 union select a.s_id,a.s_name,0 as avg_score from student a where a.s_id not in (select distinct s_id from score);
 

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
 select s.s_id,s.s_name,count(b.c_id) as sum_course,sum(b.s_score) as sum_score from 
 student s left join score b on s.s_id=b.s_id GROUP BY s.s_id,s.s_name;
 

-- 6、查询"李"姓老师的数量 
select count(t_id) from teacher where t_name like '李%';
 
-- 7、查询学过"张三"老师授课的同学的信息 
 select s.* from student s join score b on s.s_id=b.s_id where b.c_id in(select c_id from course where t_id =(select t_id from teacher where t_name = '张三'));
 

-- 8、查询没学过"张三"老师授课的同学的信息 

select * from student c where c.s_id not in(select s.s_id from student s join score b on s.s_id=b.s_id where b.c_id in(select c_id from course where t_id =(select t_id from teacher where t_name = '张三')));
 
-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select s.* from student s,score b,score c where s.s_id = b.s_id  and s.s_id = c.s_id and b.c_id='01' and c.c_id='02';
 

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
 
select s.* from student s where s.s_id in (select s_id from score where c_id='01' ) and s.s_id not in(select s_id from score where c_id='02');

-- 11、查询没有学全所有课程的同学的信息 
select s.* from  student s where s.s_id in(select s_id from score where s_id not in(
select a.s_id from score a join score b on a.s_id = b.s_id and b.c_id='02'
join score c on a.s_id = c.s_id and c.c_id='03' where a.c_id='01'));
 

-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
select * from student where s_id in(select distinct a.s_id from score a where a.c_id in(select a.c_id from score a where a.s_id='01'));
 

-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select s.* from student s where s.s_id in(select distinct s_id from score where s_id!='01' and c_id in(select c_id from score where s_id='01') group by s_id having count(1)=(select count(1) from score where s_id='01'));
 
-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
select s.s_name from student s where s.s_id not in (select s_id from score where c_id = (select c_id from course where t_id =(select t_id from teacher where t_name = '张三')) group by s_id);

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s.s_id,s.s_name,ROUND(AVG(b.s_score)) from student s left join score b on s.s_id = b.s_id where s.s_id in(select s_id from score where s_score<60 GROUP BY  s_id having count(1)>=2)GROUP BY s.s_id,s.s_name;


-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
select student.*, score.s_score from student, score
where student.s_id = score.s_id and score.s_score < 60 and c_id = "01" ORDER BY score.s_score DESC;

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
 
select *  from score 
left join (
    select s_id,avg(s_score) as avscore from score 
    group by s_id
    )r 
on score.s_id = r.s_id
order by avscore desc;
-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- --及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
 select 
score.c_id ,
max(score.s_score)as 最高分,
min(score.s_score)as 最低分,
AVG(score.s_score)as 平均分,
count(*)as 选修人数,
sum(case when score.s_score>=60 then 1 else 0 end )/count(*)as 及格率,
sum(case when score.s_score>=70 and score.s_score<80 then 1 else 0 end )/count(*)as 中等率,
sum(case when score.s_score>=80 and score.s_score<90 then 1 else 0 end )/count(*)as 优良率,
sum(case when score.s_score>=90 then 1 else 0 end )/count(*)as 优秀率 
from score
GROUP BY score.c_id
ORDER BY count(*)DESC, score.c_id ASC

-- 19、按各科成绩进行排序，并显示排名 
 
select a.c_id, a.s_id, a.s_score, count(b.s_score)+1 as rank
from score as a 
left join score as b 
on a.s_score<b.s_score and a.c_id = b.c_id
group by a.c_id, a.s_id,a.s_score
order by a.c_id, rank ASC;
-- 20、查询学生的总成绩并进行排名
set @crank=0;
select q.s_id, total, @crank := @crank +1 as rank from(
select score.s_id, sum(score.s_score) as total from score
group by score.s_id
order by total desc)q;
-- 21、查询不同老师所教不同课程平均分从高到低显示 
  select a.t_id,c.t_name,a.c_id,ROUND(avg(s_score),2) as avg_score from course a
        left join score b on a.c_id=b.c_id 
        left join teacher c on a.t_id=c.t_id
        GROUP BY a.c_id,a.t_id,c.t_name ORDER BY avg_score DESC;
-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
 select course.c_name, course.c_id,
sum(case when score.s_score<=100 and score.s_score>85 then 1 else 0 end) as "[100-85]",
sum(case when score.s_score<=85 and score.s_score>70 then 1 else 0 end) as "[85-70]",
sum(case when score.s_score<=70 and score.s_score>60 then 1 else 0 end) as "[70-60]",
sum(case when score.s_score<=60 and score.s_score>0 then 1 else 0 end) as "[60-0]"
from score left join course
on score.c_id = course.c_id
group by score.c_id;

-- 24、查询学生平均成绩及其名次 
 
select s_id,avg(s_score) as Savg from score group by s_id order by Savg asc;
 
-- 25、查询各科成绩前三名的记录
            -- 1.选出b表比a表成绩大的所有组
            -- 2.选出比当前id成绩大的 小于三个的
 select * from score a 
left join score b on a.c_id = b.c_id and a.s_score<b.s_score
order by a.c_id,a.s_score;

-- 26、查询每门课程被选修的学生数 
 select c_id, count(s_id) from score 
group by c_id;

-- 27、查询出只有两门课程的全部学生的学号和姓名 
    
select student.s_id,student.s_name
from score,student
where student.s_id=score.s_id  
GROUP BY score.s_id
HAVING count(*)=2;
-- 28、查询男生、女生人数 
     select s_sex, count(*) from student
group by s_sex;

-- 29、查询名字中含有"风"字的学生信息
select *
from student 
where student.s_name like '%风%'
  

-- 30、查询同名同性学生名单，并统计同名人数 

 select s_name, count(*) from student
group by s_name
having count(*)>1;


