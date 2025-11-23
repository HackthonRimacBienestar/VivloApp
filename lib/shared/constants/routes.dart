/// Rutas de la aplicación
class AppRoutes {
  // Autenticación
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';

  // Onboarding
  static const String onboardingIntro = '/onboarding/intro';
  static const String chronicConditions = '/onboarding/chronic-conditions';
  static const String medicationSetup = '/onboarding/medication-setup';
  static const String lifestyleQuestions = '/onboarding/lifestyle-questions';
  static const String healthGoals = '/onboarding/health-goals';
  static const String reminderPreferences = '/onboarding/reminder-preferences';
  static const String consent = '/onboarding/consent';
  static const String onboardingSummary = '/onboarding/summary';

  // Home
  static const String home = '/home';
  static const String todayTasks = '/home/today-tasks';
  static const String notificationDetail = '/home/notification-detail';
  static const String insights = '/insights';

  // Tracking
  static const String quickLog = '/tracking/quick-log';
  static const String logGlucose = '/tracking/log-glucose';
  static const String logBloodPressure = '/tracking/log-blood-pressure';
  static const String logWeight = '/tracking/log-weight';
  static const String logActivity = '/tracking/log-activity';
  static const String logSymptom = '/tracking/log-symptom';
  static const String logMedicationIntake = '/tracking/log-medication-intake';
  static const String vitalsHistory = '/tracking/vitals-history';
  static const String glucoseHistory = '/tracking/glucose-history';
  static const String bloodPressureHistory = '/tracking/blood-pressure-history';
  static const String weightHistory = '/tracking/weight-history';
  static const String medicationAdherence = '/tracking/medication-adherence';
  static const String trendsOverview = '/tracking/trends-overview';

  // Medicación
  static const String medicationList = '/medication/list';
  static const String medicationDetail = '/medication/detail';
  static const String editMedication = '/medication/edit';
  static const String medicationReminder = '/medication/reminder';
  static const String medicationRefillRequest = '/medication/refill-request';

  // Plan de Cuidado & Citas
  static const String carePlanOverview = '/care-plan/overview';
  static const String careJourneyTimeline = '/care-plan/journey-timeline';
  static const String appointmentsCalendar = '/care-plan/appointments-calendar';
  static const String appointmentsList = '/care-plan/appointments-list';
  static const String appointmentDetail = '/care-plan/appointment-detail';
  static const String newAppointment = '/care-plan/new-appointment';
  static const String rescheduleAppointment =
      '/care-plan/reschedule-appointment';
  static const String teleconsultation = '/care-plan/teleconsultation';

  // Beneficios & Servicios
  static const String benefitsHome = '/benefits/home';
  static const String benefitDetail = '/benefits/detail';
  static const String programEnrollment = '/benefits/program-enrollment';
  static const String medicationDelivery = '/benefits/medication-delivery';
  static const String labResultsList = '/benefits/lab-results-list';
  static const String labResultDetail = '/benefits/lab-result-detail';

  // Educación
  static const String educationHome = '/education/home';
  static const String articlesList = '/education/articles-list';
  static const String articleDetail = '/education/article-detail';
  static const String videosList = '/education/videos-list';
  static const String videoDetail = '/education/video-detail';
  static const String learningPrograms = '/education/learning-programs';
  static const String learningProgramDetail =
      '/education/learning-program-detail';
  static const String healthQuiz = '/education/health-quiz';
  static const String communityFeed = '/education/community-feed';
  static const String communityPostDetail = '/education/community-post-detail';
  static const String createPost = '/education/create-post';

  // Soporte
  static const String supportHome = '/support/home';
  static const String coachChatList = '/support/coach-chat-list';
  static const String coachChat = '/support/coach-chat';
  static const String helpCenter = '/support/help-center';
  static const String contactOptions = '/support/contact-options';
  static const String emergencyInfo = '/support/emergency-info';

  // Recompensas
  static const String rewardsDashboard = '/rewards/dashboard';
  static const String challengesList = '/rewards/challenges-list';
  static const String challengeDetail = '/rewards/challenge-detail';
  static const String rewardsCatalog = '/rewards/catalog';
  static const String rewardRedemption = '/rewards/redemption';
  static const String achievements = '/rewards/achievements';

  // Perfil
  static const String profile = '/profile';
  static const String profileOverview = '/profile/overview';
  static const String editProfile = '/profile/edit';
  static const String connectedDevices = '/profile/connected-devices';
  static const String notificationSettings = '/profile/notification-settings';
  static const String privacySettings = '/profile/privacy-settings';
  static const String appSettings = '/profile/app-settings';
  static const String aboutApp = '/profile/about-app';

  // Comunes
  static const String emptyState = '/common/empty-state';
  static const String noConnection = '/common/no-connection';
  static const String error = '/common/error';
  static const String permissionsRequest = '/common/permissions-request';
  static const String featureTour = '/common/feature-tour';
  static const String voiceDictation = '/voice-dictation';
  static const String voiceAgent = '/voice-agent';
}
