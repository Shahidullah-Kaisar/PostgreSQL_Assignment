# 3. Understanding Primary and Foreign Keys in PostgreSQL.

### Primary Key

Primary Key হলো একটি টেবিলের এমন একটি কলাম বা একাধিক কলামের সমন্বয় যা প্রতিটি রেকর্ডকে অন্য সব রেকর্ড থেকে আলাদা করে।
এটি অবশ্যই ইউনিক এবং null হতে পারে না।
এক টেবিলে একটি মাত্র Primary Key থাকতে পারে । এর মানে হলো Primary Key একটি কলামেও হতে পারে, আবার একাধিক কলাম মিলে (composite key) হলেও হতে পারে — কিন্তু একটির বেশি Primary Key constraint টেবিলে দেওয়া যাবে না।

#### Example

#### একটি কলাম দিয়ে Primary Key

```
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);

```
#### একাধিক কলাম মিলে Primary Key (Composite Primary Key)

```
CREATE TABLE course_enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id)
);

```

#### Primary Key এর মূল কাজগুলো:

প্রতিটি রেকর্ডকে ইউনিকভাবে শনাক্ত করা ।

টেবিলে ইউনিক মান নিশ্চিত করা ।

null মান নিষিদ্ধ করা ।

ডেটার ইন্টিগ্রিটি বজায় রাখা ।

স্বয়ংক্রিয়ভাবে ইনডেক্স তৈরি করা (indexing).


### Foreign Key

Foreign Key হলো এমন একটি কলাম, যা অন্য একটি টেবিলের Primary Key কে রেফারেন্স করে। এর মাধ্যমে দুটি টেবিলের মধ্যে সম্পর্ক তৈরি হয় ।

```
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_name VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

```
এখানে enrollments টেবিলের student_id কলামটি হলো Foreign Key, যা students টেবিলের student_id (Primary Key) কে রেফারেন্স করে।
এর মানে হলো:
enrollments টেবিলে যেই student_id থাকবে, সেটি অবশ্যই students টেবিলে আগে থেকেই থাকতে হবে।

#### Foreign Key এর মূল কাজগুলো:

ডেটা ইন্টিগ্রিটি রক্ষা করা: ভুলভাবে এমন কোনো ID ঢুকতে দেবে না যেটা মূল টেবিলে নেই ।

টেবিলের মধ্যে সম্পর্ক তৈরি করা ।

রেফারেন্স হিসাবে কাজ করা: Foreign Key মূলত অন্য টেবিলের Primary Key-এর উপর নির্ভর করে ।


# 4. Difference between the VARCHAR and CHAR data types

### CHAR

CHAR হলো স্থির দৈর্ঘ্যের (fixed-length) ডেটাটাইপ ।

CHAR সর্বদা নির্ধারিত পরিমাণ জায়গা নেয়, এমনকি ডেটা কম হলেও বাকি জায়গায় স্পেস দিয়ে পূরণ করে ।

CHAR সাধারণত Faster, কারণ ফিক্সড সাইজ বলে প্রসেসিং সহজ হয় ।

CHAR ব্যবহার করা ভালো যখন সব ডেটার দৈর্ঘ্য একই (যেমন: PIN, কোট নাম্বার)।

CHAR ডেটা ইনসার্ট করলে শেষে অটোমেটিক স্পেস যোগ হয় এবং তুলনার সময় সেই স্পেস হিসাব করে না।

### VARCHAR

VARCHAR হলো পরিবর্তনশীল দৈর্ঘ্যের (variable-length) ডেটাটাইপ।

VARCHAR শুধুমাত্র ডেটার আসল দৈর্ঘু অনুযায়ী জায়গা নেয়, অতিরিক্ত স্পেস নষ্ট হয় না।

VARCHAR একটু ধীর হতে পারে, কারণ প্রতিটি রেকর্ডের দৈর্ঘ্য ভিন্ন হতে পারে।

VARCHAR ব্যবহার করা ভালো যখন ডেটার দৈর্ঘ্য বিভিন্ন হতে পারে (যেমন: নাম, ঠিকানা)।

VARCHAR ডেটা ইনসার্ট করলে কোনো অতিরিক্ত স্পেস যোগ হয় না।

#### Example 

এইভাবে একটা CHAR(5) ফিল্ডে নাম রাখলে:

```
INSERT INTO users (name) VALUES ('Bob');

```
এখানে 'Bob' শব্দটার length 3, কিন্তু CHAR(5) বলছে ৫ অক্ষরের জায়গা লাগবে ।
তাহলে ডেটাবেজ স্বয়ংক্রিয়ভাবে এটাকে এভাবে বানাবে:

'Bob  '   

শেষের দিকে 2টা স্পেস দিয়ে মোট ৫ অক্ষর বানিয়ে ফেলবে ।

এখন তুলনার সময় কী হয়?

```
SELECT * FROM users WHERE name = 'Bob';

```

তখন SQL বুঝবে না যে 'Bob' আর 'Bob ' আলাদা কিছু ।
CHAR টাইপ তুলনার সময় শেষের স্পেসগুলো ignore করে ।
তাই 'Bob' আর 'Bob ' — এই দুইটা একই মনে করে ফলাফল দেখাবে ।


# 5. The purpose of the WHERE clause in a SELECT statement

WHERE clause ব্যবহার করা হয় condition দিয়ে ডেটা ফিল্টার করার জন্য ।
যখন SELECT দিয়ে ডেটাবেজ থেকে ডেটা নিয়ে আসি, তখন সব ডেটা না এনে যেগুলো আমাদের দেওয়া শর্ত অনুযায়ী মিলে, শুধু সেগুলোই দেখায় ।

#### Example

```
SELECT * FROM students WHERE age = 15;

```

WHERE age = 15 মানে শুধু ওইসব রেকর্ড দেখাও, যাদের বয়স 15.

WHERE না দিলে (শর্ত ছাড়া):

```
SELECT * FROM students;

```

সব রেকর্ড দেখাবে ।


# 8. The significance of the JOIN operation, and how does it work in PostgreSQL

JOIN হচ্ছে এমন একটা অপারেশন, যেটা দুই বা তার বেশি টেবিলের মধ্যে সম্পর্ক তৈরি করে একসাথে মিলিয়ে ডেটা দেখানোর জন্য ।

#### কেন দরকার হয় JOIN

একটি ডেটাবেজে সাধারণত তথ্যগুলো আলাদা আলাদা টেবিলে ভাগ করে রাখা হয়, যেন একই তথ্য বারবার লিখতে না হয়। এই পদ্ধতিকে বলে Normalization. এতে ডেটাবেজ হয় গোছানো, দ্রুততর এবং কম জায়গা নেয় ।

যেহেতু একেক টেবিলে একেক অংশের তথ্য থাকে, তাই সম্পূর্ণ তথ্য পেতে হলে টেবিলগুলোর মধ্যে সম্পর্ক তৈরি করে একসাথে দেখতে হয় ।
এই টেবিলগুলোর তাল মিলিয়ে তথ্য আনতেই প্রয়োজন হয় JOIN অপারেশনের ।

#### কিভাবে কাজ করে

JOIN অপারেশন দুইটা টেবিলের কোন নির্দিষ্ট কলামের ভিত্তিতে মিল খুঁজে রেজাল্ট তৈরি করে। PostgreSQL-এ সবচেয়ে বেশি ব্যবহৃত JOIN গুলো হলো:

#### INNER JOIN:

শুধু ওই রেকর্ডগুলো দেয় যেগুলো দুই টেবিলে ম্যাচ করে ।

```
SELECT employees.name, departments.dept_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

```

#### LEFT JOIN(LEFT OUTER JOIN):

বাম পাশের টেবিলের সব রেকর্ড দেখাবে, আর ডান পাশে না মিললে NULL দেখাবে ।

```
SELECT employees.name, departments.dept_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;

```

#### RIGHT JOIN (RIGHT OUTER JOIN):

ডান পাশের টেবিলের সব রেকর্ড দেখাবে, আর বামে না মিললে NULL.

```
SELECT employees.name, departments.dept_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;

```

#### FULL JOIN (FULL OUTER JOIN)

দুই টেবিলের সব রেকর্ডই রিটার্ন করে, মিল থাকুক বা না থাকুক।

```
SELECT employees.name, departments.dept_name
FROM employees
FULL JOIN departments ON employees.department_id = departments.id;

```

#### CROSS JOIN

দুইটা টেবিলের সব রেকর্ড একে অপরের সাথে combination করা (কার্তেসিয়ান প্রোডাক্ট) ।
যেমন: 4 employees × 3 departments = 12 রেকর্ড

```
SELECT employees.name, departments.dept_name
FROM employees
CROSS JOIN departments;

```

#### NATURAL JOIN

দুই টেবিলের মধ্যে যেসব কলামের নাম এক হয়, সেগুলো দিয়ে অটোমেটিকভাবে JOIN করা হয় ।
দুই টেবিলের একই নামে থাকা কলামগুলো একটাই কলাম হিসেবে ফলাফল টেবিলে আসে।

```
SELECT *
FROM students
NATURAL JOIN results;

```

# 9. The GROUP BY clause and its role in aggregation operations

GROUP BY ব্যবহার করে একই রকম মানগুলোকে গ্রুপে ভাগ করা যায় এবং সেই গ্রুপের ওপর aggregation function চালানো যায় ।
GROUP BY তখনই দরকার, যখন আলাদা আলাদা গ্রুপে ভাগ করে তাদের উপর হিসাব করতে হয় ।

নির্দিষ্ট কলামে যেসব সারির মান এক হয়, সেগুলোকে একসাথে গ্রুপ করে ।
একই টাইপের রেকর্ড একত্র করে তার উপর COUNT(), SUM(), AVG(), MAX(), MIN() ইত্যাদি বের করতে GROUP BY লাগে ।

#### Example

```
SELECT species, COUNT(*) 
FROM sightings
GROUP BY species;

```
GROUP BY ব্যবহার করলে

SELECT ক্লজে থাকা প্রতিটি কলাম অবশ্যই GROUP BY-এর ভিতরে থাকতে হবে অথবা কোনো aggregate function (যেমন SUM(), MIN(), MAX(), AVG(), COUNT() ইত্যাদি)-এর মধ্যে থাকতে হবে ।
