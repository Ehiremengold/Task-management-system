class Service{
  Service({required this.imagePath, required this.title, required this.description});

  final String imagePath;
  final String title;
  final String description;


  static List<Service> services () {
    return [
      Service(imagePath: 'assets/service-icons/1.png', title: 'User-Friendly', description: "Organize, prioritize, and track tasks seamlessly with our user-friendly software."),
      Service(imagePath: 'assets/service-icons/2.png', title: 'Anywhere, Anytime Task Management', description: 'Stay on top of tasks from any device, ensuring productivity on the go.'),
      Service(imagePath: 'assets/service-icons/3.png', title: 'Collaborative Productivity Booster', description: 'Streamline teamwork and achieve goals faster with our collaborative task management solution.'),
    ];
  }
}