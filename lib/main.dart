import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/services/notification_service_impl.dart';
import 'data/datasources/local_database.dart';
import 'data/repositories/agenda_repository_impl.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/usecases/agenda_usecases.dart';
import 'domain/usecases/note_usecases.dart';
import 'presentation/providers/agenda_provider.dart';
import 'presentation/providers/note_provider.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationServiceImpl();
  await notificationService.init();

  final localDb = LocalDatabase.instance;

  final noteRepository = NoteRepositoryImpl(localDb);
  final agendaRepository = AgendaRepositoryImpl(localDb);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoteProvider(
            getNotesUseCase: GetNotes(noteRepository),
            addNoteUseCase: AddNote(noteRepository),
            updateNoteUseCase: UpdateNote(noteRepository),
            deleteNoteUseCase: DeleteNote(noteRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AgendaProvider(
            getAgendasUseCase: GetAgendas(agendaRepository),
            addAgendaUseCase: AddAgenda(agendaRepository, notificationService),
            updateAgendaUseCase: UpdateAgenda(
              agendaRepository,
              notificationService,
            ),
            deleteAgendaUseCase: DeleteAgenda(
              agendaRepository,
              notificationService,
            ),
          ),
        ),
      ],
      child: const XNotesApp(),
    ),
  );
}

class XNotesApp extends StatelessWidget {
  const XNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XNotes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.deepPurpleAccent.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
