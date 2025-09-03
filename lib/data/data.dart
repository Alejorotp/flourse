import 'package:get/get.dart';
import 'package:flourse/domain/models/course.dart';
import 'package:flourse/domain/models/evaluation.dart';

var myCourses = <Course>[
  Course(title: 'Introducción a Flutter', courseCode: 'GACO26', professorID: '3', memberIds: ['1', '2'], categories: ['Mobile', 'Development']),
  Course(title: 'Diseño UX/UI', courseCode: 'ACHEYO', professorID: '3', memberIds: ['1', '2'], categories: ['Design', 'UX']),
  Course(title: 'Desarrollo de Apps Nativas', courseCode: 'TORO03', professorID: '3', memberIds: ['1'], categories: ['Mobile', 'Development']),
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
