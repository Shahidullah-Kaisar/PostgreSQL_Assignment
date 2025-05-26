# 3. Understanding Primary and Foreign Keys in PostgreSQL

## Primary Key

Primary Key হলো একটি টেবিলের এমন একটি কলাম বা একাধিক কলামের সমন্বয় যা প্রতিটি রেকর্ডকে অন্য সব রেকর্ড থেকে আলাদা করে।
এটি অবশ্যই ইউনিক এবং null হতে পারে না।
এক টেবিলে একটি মাত্র Primary Key থাকতে পারে । এর মানে হলো Primary Key একটি কলামেও হতে পারে, আবার একাধিক কলাম মিলে (composite key) হলেও হতে পারে — কিন্তু একটির বেশি Primary Key constraint টেবিলে দেওয়া যাবে না।

### Example

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

### Primary Key এর মূল কাজগুলো:

প্রতিটি রেকর্ডকে ইউনিকভাবে শনাক্ত করা ।

টেবিলে ইউনিক মান নিশ্চিত করা ।

null মান নিষিদ্ধ করা ।

ডেটার ইন্টিগ্রিটি বজায় রাখা ।

স্বয়ংক্রিয়ভাবে ইনডেক্স তৈরি করা (indexing).


## Foreign Key

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

### Foreign Key এর মূল কাজগুলো:

ডেটা ইন্টিগ্রিটি রক্ষা করা: ভুলভাবে এমন কোনো ID ঢুকতে দেবে না যেটা মূল টেবিলে নেই ।

টেবিলের মধ্যে সম্পর্ক তৈরি করা ।

রেফারেন্স হিসাবে কাজ করা: Foreign Key মূলত অন্য টেবিলের Primary Key-এর উপর নির্ভর করে ।