


--Faire une requête qui JOIN(côté gauche) les étudiants avec leurs messages.
SELECT student.student_id, student.firstname, student.lastname, forum_message.message
FROM student
LEFT JOIN forum_message
    ON student.student_id = forum_message.student_id;

--Montrer tous les étudiants sans leur matricule
SELECT student_id,firstname,lastname,departement_id
FROM student ;

--Faire un join entre la table student, forum_message et forum
SELECT student.student_id,student.firstname,student.lastname,forum_message.forum_message_id,forum_message.message,forum.forum_id,forum.title AS forum_title
FROM student
INNER JOIN forum_message
ON student.student_id = forum_message.student_id
INNER JOIN forum
ON forum_message.forum_id= forum.forum_id;

--Montrer tous les étudiants d'un cours spécifique 
SELECT course.course_id,course.title,student.firstname,student.student_id
FROM course
JOIN student_course ON course.course_id = student_course.course_id
JOIN student ON student_course.student_id = student.student_id
Where course.course_id = 9;

-- Montrer tous les cours d'un étudiant
SELECT student.student_id,student.firstname,course.title
FROM student
JOIN student_course ON student.student_id = student_course.student_id
JOIN course ON student_course.course_id = course.course_id
Where student.student_id = 3; 

--Montrer tous les cours d'un prof
SELECT prof.prof_id,prof.lastname,course.title
FROM prof
JOIN prof_course ON prof.prof_id = prof_course.prof_id
JOIN course ON prof_course.course_id = course.course_id
where prof.prof_id = 2 ;

--Montrer tous les profs dans un cours spécifique.
SELECT course.course_id,course.title,prof.lastname,prof.prof_id
FROM course
JOIN prof_course ON course.course_id = prof_course.course_id
JOIN prof ON prof_course.prof_id = prof.prof_id
Where course.course_id = 2;

--Monter tous les étudiants et les profs dans le départment d'informatique, sélectionné à partir du title de department
-- Étudiants
SELECT s.student_id, s.firstname, s.lastname,'Étudiant' AS role
FROM student s
JOIN departement d ON d.departement_id = s.departement_id
WHERE (d.title) = 'INFORMATIQUE'

UNION

SELECT p.prof_id, p.firstname, p.lastname,'Professeur' AS role
FROM prof p
JOIN departement d ON d.departement_id = p.departement_id
WHERE (d.title) = 'INFORMATIQUE';

--Montrer les profs d'une personne étudiante.
SELECT DISTINCT p.prof_id,
       p.firstname,
       p.lastname,
       c.course_id,
       c.title,
       s.student_id
FROM student s
JOIN student_course sc ON s.student_id = sc.student_id
JOIN course c ON sc.course_id = c.course_id
JOIN prof_course pc ON c.course_id = pc.course_id
JOIN prof p ON pc.prof_id = p.prof_id
WHERE s.student_id = 5;

/*Pour un cours de votre choix, sélectionné par ID, faire le total (SUM) des travaux, et
retourner le résultat dans une nouvelle colonne nommée running_total. Le running_total
doit incrémenter par addition aux valeurs précédentes et segmenté (partition) par type d'évaluation
(i.e. examen ou travail pratique).*/

SELECT 
    e.evaluation_id,
    e.name AS evaluation_name,
    e.type AS evaluation_type,
    sc.student_id,
    sc.total_grade,
    SUM(sc.total_grade) OVER (
        PARTITION BY e.type 
        ORDER BY e.evaluation_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM evaluation e
JOIN student_course sc ON e.course_id = sc.course_id
WHERE e.course_id = 3
ORDER BY e.type, e.evaluation_id;

