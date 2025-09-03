import 'package:flourse/domain/models/course.dart';
import 'package:flourse/domain/models/evaluation.dart';

final List<Course> myCourses = [
  Course(title: 'Introducción a Flutter', role: 'Estudiante', members: 3, memberIds: ['id1', 'id2', 'id3'], categories: ['Mobile', 'Development']),
  Course(title: 'Diseño UX/UI', role: 'Profesor', members: 4, memberIds: ['id1', 'id2', 'id3', 'id4'], categories: ['Design', 'UX']),
  Course(title: 'Desarrollo de Apps Nativas', role: 'Estudiante', members: 2, memberIds: ['id1', 'id2'], categories: ['Mobile', 'Development']),
];

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