/// Temporary in-memory seed data for the admin jobs flow.
///
/// This file should be removed once real data is wired up.
import 'package:americas_perfect_home/models/job.dart';

final List<Job> fakeJobs = <Job>[
  Job(
    id: 'job-1',
    name: 'Bathroom Remodel',
    customerName: 'Alex Johnson',
    address: '123 Maple St, Springfield',
    status: JobStatus.inProgress,
    startDate: DateTime(2024, 3, 12),
    estimatedBudget: 18000,
    totalHours: 120,
    hourlyRate: 55,
    notes:
        'Complete renovation of the master bathroom including new fixtures.',
  ),
  Job(
    id: 'job-2',
    name: 'Extra Bedroom Addition',
    customerName: 'Jamie Lee',
    address: '88 Lakeview Dr, Riverton',
    status: JobStatus.scheduled,
    startDate: DateTime(2024, 4, 5),
    estimatedBudget: 42000,
    totalHours: 260,
    hourlyRate: 60,
    notes: 'Add an additional bedroom above the garage with ensuite bath.',
  ),
  Job(
    id: 'job-3',
    name: 'Kitchen Remodel',
    customerName: 'Morgan Smith',
    address: '457 Oak Ave, Fairview',
    status: JobStatus.lead,
    startDate: DateTime(2024, 5, 2),
    estimatedBudget: 35000,
    totalHours: 180,
    hourlyRate: 58,
    notes: 'Full kitchen update with new cabinets, countertops, and flooring.',
  ),
  Job(
    id: 'job-4',
    name: 'Deck Replacement',
    customerName: 'Taylor Brown',
    address: '19 Pine Rd, Brookside',
    status: JobStatus.completed,
    startDate: DateTime(2023, 11, 18),
    estimatedBudget: 15000,
    totalHours: 90,
    hourlyRate: 50,
    notes: 'Replace aging backyard deck with composite materials.',
  ),
  Job(
    id: 'job-5',
    name: 'Exterior Repaint',
    customerName: 'Jordan Davis',
    address: '602 Elm St, Lakeside',
    status: JobStatus.onHold,
    startDate: DateTime(2024, 2, 8),
    estimatedBudget: 12000,
    totalHours: 75,
    hourlyRate: 45,
    notes: 'Full exterior repaint awaiting HOA approval.',
  ),
];
