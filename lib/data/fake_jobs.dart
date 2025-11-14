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
    activeEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-1',
        name: 'Chris Evans',
        hourlyRate: 55,
        hoursWorked: 42,
      ),
      EmployeeAssignment(
        id: 'emp-2',
        name: 'Robin Chen',
        hourlyRate: 48,
        hoursWorked: 30,
      ),
    ],
    pastEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-8',
        name: 'Jordan Smith',
        hourlyRate: 52,
        hoursWorked: 18,
      ),
    ],
    materials: <MaterialItem>[
      MaterialItem(
        name: 'Ceramic Tile',
        quantity: 200,
        quotedCost: 2400,
        actualCost: 2550,
      ),
      MaterialItem(
        name: 'Vanity',
        quantity: 1,
        quotedCost: 1200,
        actualCost: 1150,
      ),
    ],
    tasks: <JobTask>[
      JobTask(
        id: 'task-1',
        title: 'Demolition',
        assignedEmployeeId: 'emp-1',
        status: JobTaskStatus.complete,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
      JobTask(
        id: 'task-2',
        title: 'Plumbing Rough-In',
        assignedEmployeeId: 'emp-2',
        status: JobTaskStatus.inReview,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
      JobTask(
        id: 'task-3',
        title: 'Tile Installation',
        assignedEmployeeId: 'emp-1',
        status: JobTaskStatus.inProgress,
        hasBeforePhoto: true,
        hasAfterPhoto: false,
      ),
      JobTask(
        id: 'task-4',
        title: 'Fixture Installation',
        assignedEmployeeId: 'emp-2',
        status: JobTaskStatus.notStarted,
        hasBeforePhoto: false,
        hasAfterPhoto: false,
      ),
    ],
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
    activeEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-3',
        name: 'Alex Kim',
        hourlyRate: 60,
        hoursWorked: 15,
      ),
      EmployeeAssignment(
        id: 'emp-4',
        name: 'Samira Patel',
        hourlyRate: 58,
        hoursWorked: 20,
      ),
    ],
    pastEmployees: <EmployeeAssignment>[],
    materials: <MaterialItem>[
      MaterialItem(
        name: 'Lumber',
        quantity: 450,
        quotedCost: 5200,
        actualCost: 5150,
      ),
      MaterialItem(
        name: 'Drywall',
        quantity: 120,
        quotedCost: 1500,
        actualCost: 0,
      ),
    ],
    tasks: <JobTask>[
      JobTask(
        id: 'task-5',
        title: 'Foundation Work',
        assignedEmployeeId: 'emp-3',
        status: JobTaskStatus.notStarted,
      ),
      JobTask(
        id: 'task-6',
        title: 'Framing',
        assignedEmployeeId: 'emp-4',
        status: JobTaskStatus.notStarted,
      ),
    ],
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
    activeEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-5',
        name: 'Daniel White',
        hourlyRate: 58,
        hoursWorked: 12,
      ),
    ],
    pastEmployees: <EmployeeAssignment>[],
    materials: <MaterialItem>[
      MaterialItem(
        name: 'Cabinets',
        quantity: 15,
        quotedCost: 7500,
        actualCost: 0,
      ),
      MaterialItem(
        name: 'Countertops',
        quantity: 40,
        quotedCost: 6200,
        actualCost: 0,
      ),
    ],
    tasks: <JobTask>[
      JobTask(
        id: 'task-7',
        title: 'Design Approval',
        status: JobTaskStatus.complete,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
      JobTask(
        id: 'task-8',
        title: 'Cabinet Removal',
        status: JobTaskStatus.inProgress,
        hasBeforePhoto: true,
      ),
      JobTask(
        id: 'task-9',
        title: 'Electrical Rough-In',
        status: JobTaskStatus.notStarted,
      ),
    ],
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
    activeEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-6',
        name: 'Nina Lopez',
        hourlyRate: 50,
        hoursWorked: 80,
      ),
    ],
    pastEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-9',
        name: 'Taylor Brooks',
        hourlyRate: 46,
        hoursWorked: 25,
      ),
    ],
    materials: <MaterialItem>[
      MaterialItem(
        name: 'Composite Boards',
        quantity: 300,
        quotedCost: 4000,
        actualCost: 4200,
      ),
      MaterialItem(
        name: 'Support Posts',
        quantity: 25,
        quotedCost: 1200,
        actualCost: 1100,
      ),
    ],
    tasks: <JobTask>[
      JobTask(
        id: 'task-10',
        title: 'Demolition',
        status: JobTaskStatus.complete,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
      JobTask(
        id: 'task-11',
        title: 'Footings',
        status: JobTaskStatus.complete,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
      JobTask(
        id: 'task-12',
        title: 'Decking Install',
        status: JobTaskStatus.complete,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
    ],
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
    activeEmployees: <EmployeeAssignment>[
      EmployeeAssignment(
        id: 'emp-7',
        name: 'Leslie Ford',
        hourlyRate: 45,
        hoursWorked: 6,
      ),
    ],
    pastEmployees: <EmployeeAssignment>[],
    materials: <MaterialItem>[
      MaterialItem(
        name: 'Exterior Paint',
        quantity: 20,
        quotedCost: 900,
        actualCost: 0,
      ),
      MaterialItem(
        name: 'Primer',
        quantity: 10,
        quotedCost: 300,
        actualCost: 0,
      ),
    ],
    tasks: <JobTask>[
      JobTask(
        id: 'task-13',
        title: 'Power Wash',
        status: JobTaskStatus.inReview,
        hasBeforePhoto: true,
        hasAfterPhoto: true,
      ),
      JobTask(
        id: 'task-14',
        title: 'Scrape & Prep',
        status: JobTaskStatus.inProgress,
        hasBeforePhoto: true,
      ),
      JobTask(
        id: 'task-15',
        title: 'Final Coat',
        status: JobTaskStatus.notStarted,
      ),
    ],
  ),
];
