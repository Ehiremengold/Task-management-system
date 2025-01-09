import 'package:flutter/material.dart';

class PriorityIndicator {
  PriorityIndicator({required this.priority});
  final String priority;

  Color getColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class Task {
  Task({
    required this.name,
    required this.status,
    required this.priority,
    required this.due_date,
    required this.created,
  });

  final String name;
  final String status;
  final String priority;
  final String due_date;
  final String created;

  static List<Task> tasks() {
    return [
      Task(
          name: "Update user authentication flow",
          status: "Completed",
          priority: "Medium",
          due_date: "Apr 24, 2024",
          created: "Now"),
      Task(
          name: "Implement dark mode toggle",
          status: "Incomplete",
          priority: "Low",
          due_date: "Jun 12, 2024",
          created: "Today"),
      Task(
          name: "Refactor data model classes",
          status: "In progress",
          priority: "High",
          due_date: "Mar 1, 2024",
          created: "Today"),
      Task(
          name: "Optimize database queries",
          status: "Incomplete",
          priority: "Medium",
          due_date: "Jan 2, 2025",
          created: "Yesterday"),
      Task(
          name: "Design new onboarding screens",
          status: "Completed",
          priority: "High",
          due_date: "Sept 8, 2024",
          created: "3 days ago"),
      Task(
          name: "Improve error handling in API requests",
          status: "In progress",
          priority: "High",
          due_date: 'Aug 30, 2024',
          created: "5 days ago"),
      Task(
          name: "Add push notification support",
          status: "Completed",
          priority: "Low",
          due_date: 'Apr  12, 2024',
          created: "1 week ago"),
      Task(
          name: "Create user profile screen UI",
          status: "Incomplete",
          priority: "Medium",
          due_date: "Apr 1, 2024 ",
          created: "1 week ago"),
      Task(
          name: "Integrate analytics tracking",
          status: "In progress",
          priority: "High",
          due_date: "May 15, 204",
          created: "1 week ago"),
      Task(
          name: "Write unit tests for utility functions",
          status: "Incomplete",
          priority: "Medium",
          due_date: "Jul 11, 2024",
          created: "2 weeks ago"),
    ];
  }
}

class Review {
  const Review(
      {required this.name,
      required this.job_description,
      required this.review,
      required this.imagePath,
      required this.stars});

  final String name;
  final String job_description;
  final String review;
  final String imagePath;
  final int stars;

  static List<Review> reviews() {
    return [
      const Review(
          name: "Samantha L.",
          job_description: "WebFlow Designer",
          review:
              "TaskMaster Pro has revolutionized my project management. The intuitive interface, seamless calendar and email integration, and customizable reminders are fantastic. Highly recommend for productivity!",
          imagePath: 'assets/review_users/1.jpg',
          stars: 5),
      const Review(
          name: "Michael B.",
          job_description: "UX Writer",
          review:
              "A powerful tool with excellent task prioritization and productivity analytics. However, the mobile app has sync issues. Web version works flawlessly and support is helpful.",
          imagePath: "assets/review_users/2.jpg",
          stars: 4),
      const Review(
          name: "Priya K.",
          job_description: "Flutter Developer",
          review:
              "Indispensable for team projects. Easy task assignment, deadline setting, and real-time progress monitoring. User-friendly, even for non-tech-savvy team members. Improved our productivity.",
          imagePath: "assets/review_users/3.jpg",
          stars: 5),
      const Review(
          name: "Jordan W.",
          job_description: "Project Manager",
          review:
              "Great task organization but runs slow with large projects. Reporting tools could be more advanced. Hoping future updates address these issues.",
          imagePath: "assets/review_users/4.jpg",
          stars: 3),
      const Review(
          name: "Ricardo G.",
          job_description: "Software Engineer",
          review:
              "Offers comprehensive task management and third-party app integration. UI could be more modern. Despite this, a solid choice for efficiency.",
          imagePath: "assets/review_users/5.jpg",
          stars: 4)
    ];
  }
}
