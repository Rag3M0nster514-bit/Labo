Drop table IF EXISTS departement cascade;

Create TABLE departement(
    departement_id int PRIMARY KEY,
    title VARCHAR(30)NOT NULL,
    sigle VARCHAR(10) NOT NULL
);
Drop table IF EXISTS student cascade;
Create TABLE student (
    student_id int PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    matricule VARCHAR(20) NOT NULL,
    departement_id int,
    FOREIGN KEY(departement_id) References departement(departement_id)
);
DROP TABLE IF EXISTS course cascade;
CREATE TABLE course ( 
    course_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL, 
    sigle VARCHAR(15) NOT NULL,
    departement_id int,
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id)
);

drop table IF EXISTS student_course;
Create TABLE student_course(
    student_id int NOT NULL,
    course_id int Not NULL,
    total_grade int, 
    FOREIGN KEY (student_id) References student(student_id) ON DELETE CASCADE ,
    FOREIGN KEY (course_id) References course(course_id) ON DELETE CASCADE,
    CONSTRAINT unique_student_course UNIQUE(student_id, course_id)
);
drop table IF EXISTS prof cascade ;
Create TABLE prof(
    prof_id int PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    departement_id int,
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id)ON DELETE CASCADE
);
drop table IF EXISTS prof_course ;
Create TABLE prof_course(
    course_id int,
    prof_id int,
    FOREIGN KEY (course_id) References course(course_id) ON DELETE CASCADE,
    FOREIGN KEY(prof_id) References prof(prof_id)ON DELETE CASCADE
);

drop table IF EXISTS forum cascade;
Create TABLE forum(
    forum_id int PRIMARY KEY,
    title VARCHAR(20) NOT NULL,
    course_id int,
    FOREIGN KEY(course_id) References course (course_id) ON DELETE CASCADE

);
drop table IF EXISTS forum_message ;
Create TABLE forum_message(
    forum_message_id int PRIMARY KEY,
    message VARCHAR(50) NOT NULL,
    student_id int,
    prof_id int,
    forum_id int,
    FOREIGN KEY(student_id)References student (student_id)ON DELETE CASCADE,
    FOREIGN KEY(prof_id)References prof (prof_id)ON DELETE CASCADE,
    FOREIGN KEY(forum_iD)References forum (forum_id) ON DELETE CASCADE
);
drop table IF EXISTS evaluation cascade;
Create TABLE evaluation(
    evaluation_id int PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL,
    due_datetime DATE,
    course_id int,
    FOREIGN KEY(course_id)References course (course_id) ON DELETE CASCADE
);
drop table IF EXISTS evaluation_file;
Create TABLE evaluation_file(
    evaluation_file_id int PRIMARY KEY,
    bucket_url VARCHAR(255) NOT NULL,
    evaluation_id int ,
    FOREIGN KEY(evaluation_id)References evaluation (evaluation_id) ON DELETE CASCADE

);
-- Dépt. "Informatique" filtré par titre + joins
CREATE INDEX IF NOT EXISTS idx_departement_title         ON departement(title);
CREATE INDEX IF NOT EXISTS idx_course_departement        ON course(departement_id);




-- Joins forum / messages
CREATE INDEX IF NOT EXISTS idx_forum_message_student     ON forum_message(student_id);
CREATE INDEX IF NOT EXISTS idx_forum_message_forum       ON forum_message(forum_id);


-- Joins profs ↔ cours (et éviter les doublons)
CREATE UNIQUE INDEX IF NOT EXISTS uq_prof_course         ON prof_course(prof_id, course_id);


-- Joins étudiants ↔ cours (tu as déjà une contrainte UNIQUE qui crée l’index,
-- mais on s’assure de l’ordre des colonnes utile aux recherches par étudiant)
CREATE INDEX IF NOT EXISTS idx_student_course_student    ON student_course(student_id);
CREATE INDEX IF NOT EXISTS idx_student_course_course     ON student_course(course_id);
