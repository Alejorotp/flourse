import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:get/get.dart';
import 'package:flourse/features/courses/domain/models/course.dart';
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/auth/domain/models/authentication_user.dart';

var myCourses = <Course>[
  Course(
    title: 'Introducción a Flutter',
    courseCode: 'GACO26',
    professorID: 3,
    memberIDs: [1, 2],
    categoryIDs: [1, 2],
  ),
  Course(
    title: 'Diseño UX/UI',
    courseCode: 'ACHEYO',
    professorID: 3,
    memberIDs: [1, 2],
    categoryIDs: [3],
  ),
  Course(
    title: 'Desarrollo de Apps Nativas',
    courseCode: 'TORO03',
    professorID: 3,
    memberIDs: [1],
    categoryIDs: [],
  ),
  Course(
    title: 'Compromiso con el medio ambiente',
    courseCode: 'COMP03',
    professorID: 1,
    memberIDs: [2, 3, 4],
    categoryIDs: [4],
  ),
  Course(
    title: 'curso1',
    courseCode: 'CURSO1',
    professorID: 2,
    memberIDs: [6],
    categoryIDs: [],
  )
].obs;

final List<Evaluation> upcomingEvaluations = [
  Evaluation(
    title: 'Quiz de Fundamentos',
    course: 'Introducción a Flutter',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    timeRemaining: 'Today · 23 min',
  ),
  Evaluation(
    title: 'Examen de Usabilidad',
    course: 'Diseño UX/UI',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    timeRemaining: 'Tomorrow · 23h 23 min',
  ),
  Evaluation(
    title: 'Proyecto Final',
    course: 'Desarrollo de Apps Nativas',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    timeRemaining: '2 Days Left · 47h 23 min',
  ),
];

final List<Category> myCategories = [
  Category(
    id: 1,
    name: 'Mobile Assignment 1',
    groupingMethod: 'Random',
    maxMembers: 5,
  ),
  Category(
    id: 2,
    name: 'Mobile Assignment 2',
    groupingMethod: 'Self-assigned',
    maxMembers: 3,
  ),
  Category(
    id: 3,
    name: 'Mobile Assignment 3',
    groupingMethod: 'Random',
    maxMembers: 4,
  ),
  Category(
    id: 4,
    name: 'Mobile Assignment 4',
    groupingMethod: 'Self-assigned',
    maxMembers: 2,
  ),
  Category(
    id: 5,
    name: 'Mobile Assignment 5',
    groupingMethod: 'Random',
    maxMembers: 6,
  ),
];

// Simulación de base de datos en memoria
final fakeUsers = <String, AuthenticationUser>{
  // No sé que hace o porqué está ahí el primer string antes de los 2 puntos :)
  "manuel@test.com": AuthenticationUser(
    id: 1,
    name: "Manuel",
    email: "manuel@test.com",
    password: "123456",
  ),
  "ana@test.com": AuthenticationUser(
    id: 2,
    name: "Ana",
    email: "ana@test.com",
    password: "qwerty",
  ),
  "gaco@test.com": AuthenticationUser(
    id: 3,
    name: "Gaco",
    email: "gaco@test.com",
    password: "abcd",
  ),
  "none@test.com": AuthenticationUser(
    id: 4,
    name: "none",
    email: "none@test.com",
    password: "abcd",
  ),
  "a@a.com": AuthenticationUser(
    id: 5,
    name: "a",
    email: "a@a.com",
    password:"123456",
  ),
  "b@a.com":AuthenticationUser(
    id: 6,
    name: "b",
    email: "b@a.com",
    password:"123456",
  ),
  "c@a.com":AuthenticationUser(
    id: 7,
    name: "c",
    email: "c@a.com",
    password:"123456",
  ),
};
