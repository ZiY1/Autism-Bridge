class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

//TODO: slogans are tentative
final slideList = [
  Slide(
    imageUrl: 'images/welcome_career_progress.png',
    title: 'Build your resume with Autism Bridge',
    description: 'Career according to your need, make job application easier',
  ),
  Slide(
    imageUrl: 'images/welcome_job_hunt.png',
    title: 'Find your desired job with Autism Bridge',
    description: 'Career according to your need, make job application easier',
  ),
  Slide(
    imageUrl: 'images/welcome_vr_interview.png',
    title: 'Start a VR interview with Autism Bridge',
    description: 'Career according to your need, make job application easier',
  ),
];
