import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // TODO: Replace with your actual Supabase URL and Anon Key
    url: 'https://lannraqeedzzcujhfdwf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxhbm5yYXFlZWR6emN1amhmZHdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4NTM1ODMsImV4cCI6MjA3OTQyOTU4M30.Letl3BOcnwpZaKYIyWUtO9tiVIkoRR2kR-jFNk9Ixsk',
  );

  await InjectionContainer.init();

  runApp(const App());
}
