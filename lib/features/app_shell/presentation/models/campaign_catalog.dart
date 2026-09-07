import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

@immutable
class CampaignCategory {
  const CampaignCategory({
    required this.name,
    required this.emoji,
    required this.description,
    required this.color,
    required this.campaignCount,
  });
  final String name;
  final String emoji;
  final String description;
  final Color color;
  final int campaignCount;
}

@immutable
class CampaignMilestone {
  const CampaignMilestone(
    this.title,
    this.dateAmount, {
    this.completed = false,
  });
  final String title;
  final String dateAmount;
  final bool completed;
}

@immutable
class CampaignUpdate {
  const CampaignUpdate(
    this.title,
    this.when,
    this.message, {
    this.emoji = '📣',
  });
  final String title;
  final String when;
  final String message;
  final String emoji;
}

@immutable
class CampaignData {
  const CampaignData({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryKey,
    required this.amount,
    required this.goal,
    required this.progress,
    required this.location,
    required this.icon,
    required this.gradient,
    required this.donors,
    required this.daysLeft,
    required this.fundraiser,
    required this.story,
    required this.milestones,
    required this.updates,
    this.organisation = false,
    this.status = CampaignStatus.active,
  });

  final String id;
  final String title;
  final String category;
  final String categoryKey;
  final String amount;
  final String goal;
  final double progress;
  final String location;
  final String icon;
  final Gradient gradient;
  final int donors;
  final int daysLeft;
  final String fundraiser;
  final String story;
  final List<CampaignMilestone> milestones;
  final List<CampaignUpdate> updates;
  final bool organisation;
  final CampaignStatus status;

  List<String> get gallery => [icon, '🛠️', '🤝', '📍'];
}

enum CampaignStatus { active, closed, suspended }

abstract final class CampaignCatalog {
  static const education = CampaignCategory(
    name: 'Education',
    emoji: '📚',
    campaignCount: 1847,
    description:
        'Support learners from early childhood through higher education across the world.',
    color: Color(0xFF679CF0),
  );
  static const health = CampaignCategory(
    name: 'Health',
    emoji: '🏥',
    campaignCount: 2341,
    description:
        'Fund medical treatments, mental health resources, and community health programs.',
    color: Color(0xFFF27676),
  );
  static const crisis = CampaignCategory(
    name: 'Crisis',
    emoji: '🆘',
    campaignCount: 968,
    description:
        'Help communities respond quickly when disasters and emergencies strike.',
    color: Color(0xFFF4B756),
  );
  static const agriculture = CampaignCategory(
    name: 'Agriculture',
    emoji: '🌾',
    campaignCount: 634,
    description:
        'Empower farmers, cooperatives, and rural food producers worldwide.',
    color: Color(0xFF9BD95A),
  );
  static const environment = CampaignCategory(
    name: 'Environment',
    emoji: '🌱',
    campaignCount: 721,
    description: 'Protect nature and support climate-positive local projects.',
    color: Color(0xFF67CE86),
  );
  static const community = CampaignCategory(
    name: 'Community',
    emoji: '🏘️',
    campaignCount: 1102,
    description:
        'Bring neighbours together to build stronger local communities.',
    color: Color(0xFF9A77F0),
  );
  static const water = CampaignCategory(
    name: 'Water',
    emoji: '💧',
    campaignCount: 885,
    description:
        'Bring clean, reliable water to communities that need it most.',
    color: Color(0xFF52C4DA),
  );
  static const categories = [
    education,
    health,
    crisis,
    agriculture,
    environment,
    community,
    water,
  ];

  static const communityCentre = CampaignData(
    id: 'community-centre',
    title: 'Help rebuild our community centre',
    category: 'Community Dev.',
    categoryKey: 'Community',
    amount: '\$14,400',
    goal: '\$20,000',
    progress: .72,
    location: 'Lagos, Nigeria',
    icon: '🏘️',
    gradient: AppColors.cardGradient,
    donors: 248,
    daysLeft: 12,
    fundraiser: 'Marcus Johnson',
    story:
        'Our community centre has been the heartbeat of Surulere for over 30 years. Severe flooding damaged the main hall, library, and playground beyond safe use. Your support will rebuild a welcoming space for childcare, learning, and community gatherings.',
    milestones: [
      CampaignMilestone(
        'Structural repairs',
        'Aug 30 · \$8,000',
        completed: true,
      ),
      CampaignMilestone('Main hall rebuild', 'Sep 30 · \$14,000'),
      CampaignMilestone('Library restock', 'Oct 20 · \$20,000'),
    ],
    updates: [
      CampaignUpdate(
        'Roof repairs complete!',
        '3 days ago',
        'The structural team finished ahead of schedule. We now have a weatherproof building for the first time in eight months. Thank you all so much.',
        emoji: '🎉',
      ),
      CampaignUpdate(
        'Volunteer day announced',
        '1 week ago',
        'Neighbours are gathering this Saturday to prepare the library for reopening.',
      ),
    ],
  );
  static const leahTreatment = CampaignData(
    id: 'leah-treatment',
    title: "Medical expenses for Leah's treatment",
    category: 'Health',
    categoryKey: 'Health',
    amount: '\$8,700',
    goal: '\$15,000',
    progress: .58,
    location: 'Nairobi, Kenya',
    icon: '🏥',
    gradient: LinearGradient(colors: [Color(0xFFFF4545), Color(0xFFFF791E)]),
    donors: 133,
    daysLeft: 21,
    fundraiser: 'Priya Sharma',
    story:
        'Leah is a 7-year-old girl from Westlands, Nairobi, recently diagnosed with acute lymphoblastic leukaemia. Funds will cover chemotherapy, tests, transport, and the care her family needs during treatment.',
    milestones: [
      CampaignMilestone(
        'First chemo cycle',
        'Sep 1 · \$5,000',
        completed: true,
      ),
      CampaignMilestone('Second chemo cycle', 'Oct 15 · \$10,000'),
      CampaignMilestone('Recovery support', 'Nov 30 · \$15,000'),
    ],
    updates: [
      CampaignUpdate(
        'Cycle 1 complete',
        '2 weeks ago',
        'Leah finished her first round of chemotherapy yesterday. Doctors are cautiously optimistic. She sends her love and thanks to every donor.',
        emoji: '💪',
      ),
    ],
  );
  static const ruralSchool = CampaignData(
    id: 'rural-school',
    title: 'School supplies for rural Kenya',
    category: 'Education',
    categoryKey: 'Education',
    amount: '\$3,200',
    goal: '\$5,000',
    progress: .64,
    location: 'Kisumu, Kenya',
    icon: '📚',
    gradient: LinearGradient(colors: [Color(0xFF3495F4), Color(0xFF12B5D7)]),
    donors: 89,
    daysLeft: 18,
    fundraiser: 'Amina Otieno',
    story:
        'Help equip classrooms in rural Kisumu with books, desks, pencils, and learning materials for children beginning a new school year.',
    milestones: [
      CampaignMilestone('Books delivered', 'Aug 20 · \$2,000', completed: true),
      CampaignMilestone('Classroom kits', 'Sep 15 · \$5,000'),
    ],
    updates: [
      CampaignUpdate(
        'First books delivered',
        '4 days ago',
        'The first set of books has arrived safely at the school library.',
        emoji: '📖',
      ),
    ],
  );
  static const turkanaWells = CampaignData(
    id: 'turkana-wells',
    title: 'Clean water wells for Turkana County',
    category: 'Water & Sanitation',
    categoryKey: 'Water',
    amount: '\$19,200',
    goal: '\$25,000',
    progress: .77,
    location: 'Turkana, Kenya',
    icon: '💧',
    gradient: LinearGradient(colors: [Color(0xFF12B5D7), Color(0xFF2B57A5)]),
    donors: 412,
    daysLeft: 7,
    fundraiser: 'WaterAid Kenya',
    organisation: true,
    story:
        'In Turkana County, women and girls walk kilometres each day to collect water that is often contaminated. This campaign will complete boreholes and train local water committees to maintain them.',
    milestones: [
      CampaignMilestone(
        'Borehole 1 drilled',
        'Jul 30 · \$8,500',
        completed: true,
      ),
      CampaignMilestone(
        'Borehole 2 drilled',
        'Aug 31 · \$17,000',
        completed: true,
      ),
      CampaignMilestone('Water committee training', 'Sep 20 · \$25,000'),
    ],
    updates: [
      CampaignUpdate(
        'Two wells operational!',
        '1 week ago',
        'Sites A and B are now serving 2,400 people with clean water. The community celebration at Kakuma was incredible — thank you.',
        emoji: '💧',
      ),
    ],
  );
  static const moroccoRelief = CampaignData(
    id: 'morocco-relief',
    title: 'Disaster relief — Morocco earthquake',
    category: 'Crisis Support',
    categoryKey: 'Crisis',
    amount: '\$31,000',
    goal: '\$40,000',
    progress: .78,
    location: 'Marrakech, Morocco',
    icon: '🌊',
    gradient: LinearGradient(colors: [Color(0xFFF12E23), Color(0xFFAB3A11)]),
    donors: 416,
    daysLeft: 5,
    fundraiser: 'Relief Together',
    organisation: true,
    story:
        'Emergency shelter, food parcels, and essential medicine are being delivered to families affected by the earthquake in the Atlas region.',
    milestones: [
      CampaignMilestone(
        'Emergency kits delivered',
        'Aug 12 · \$20,000',
        completed: true,
      ),
      CampaignMilestone('Temporary shelter', 'Sep 8 · \$40,000'),
    ],
    updates: [
      CampaignUpdate(
        'Shelter delivery underway',
        'Yesterday',
        'Our teams have reached three remote villages with temporary shelter kits.',
      ),
    ],
  );
  static const foodParcels = CampaignData(
    id: 'food-parcels',
    title: 'Emergency food parcels for families',
    category: 'Crisis Support',
    categoryKey: 'Crisis',
    amount: '\$6,100',
    goal: '\$8,000',
    progress: .76,
    location: 'Tema, Ghana',
    icon: '🍚',
    gradient: LinearGradient(colors: [Color(0xFFE97B09), Color(0xFFC63928)]),
    donors: 97,
    daysLeft: 10,
    fundraiser: 'Tema Food Bank',
    organisation: true,
    story:
        'Food parcels with staple grains, oil, and nutritious essentials will reach families facing an immediate shortage.',
    milestones: [
      CampaignMilestone(
        '100 parcels packed',
        'Aug 18 · \$4,000',
        completed: true,
      ),
      CampaignMilestone('200 parcels delivered', 'Sep 12 · \$8,000'),
    ],
    updates: [
      CampaignUpdate(
        'First deliveries complete',
        '2 days ago',
        'One hundred families received a full week of food supplies.',
        emoji: '🤝',
      ),
    ],
  );
  static const urbanTrees = CampaignData(
    id: 'urban-trees',
    title: 'Plant trees across urban schools',
    category: 'Environment',
    categoryKey: 'Environment',
    amount: '\$9,400',
    goal: '\$15,500',
    progress: .61,
    location: 'Kampala, Uganda',
    icon: '🌱',
    gradient: LinearGradient(colors: [Color(0xFF54C86B), Color(0xFF189F86)]),
    donors: 156,
    daysLeft: 32,
    fundraiser: 'Green Kampala',
    organisation: true,
    story:
        'Students will plant and care for shade trees that cool their school grounds and create greener neighbourhoods.',
    milestones: [
      CampaignMilestone(
        '500 seedlings sourced',
        'Aug 25 · \$7,000',
        completed: true,
      ),
      CampaignMilestone('School planting days', 'Oct 5 · \$15,500'),
    ],
    updates: [
      CampaignUpdate(
        'Schools sign up',
        '5 days ago',
        'Twelve schools have now signed up for their planting day.',
        emoji: '🌳',
      ),
    ],
  );
  static const maternalCare = CampaignData(
    id: 'maternal-care',
    title: 'Safe births for rural mothers',
    category: 'Health',
    categoryKey: 'Health',
    amount: '\$12,100',
    goal: '\$18,000',
    progress: .67,
    location: 'Tamale, Ghana',
    icon: '🩺',
    gradient: LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFE53935)]),
    donors: 184,
    daysLeft: 16,
    fundraiser: 'Dr. Naa Mensah',
    story:
        'This maternal-care programme provides transport, supplies, and trained support for mothers giving birth in rural communities.',
    milestones: [
      CampaignMilestone('Clinic supplies', 'Aug 29 · \$9,000', completed: true),
      CampaignMilestone('Transport fund', 'Sep 25 · \$18,000'),
    ],
    updates: [
      CampaignUpdate(
        'Midwives trained',
        '6 days ago',
        'Eight community midwives completed their emergency-care training.',
        emoji: '🩺',
      ),
    ],
  );
  static const libraryBus = CampaignData(
    id: 'library-bus',
    title: 'A mobile library for young readers',
    category: 'Education',
    categoryKey: 'Education',
    amount: '\$4,600',
    goal: '\$9,000',
    progress: .51,
    location: 'Kumasi, Ghana',
    icon: '🚌',
    gradient: LinearGradient(colors: [Color(0xFF7E57C2), Color(0xFF42A5F5)]),
    donors: 74,
    daysLeft: 25,
    fundraiser: 'Read Forward',
    organisation: true,
    story:
        'A converted bus will bring books, literacy games, and reading mentors to children who have no local library.',
    milestones: [
      CampaignMilestone('Bus secured', 'Aug 15 · \$4,000', completed: true),
      CampaignMilestone('Shelves and books', 'Oct 1 · \$9,000'),
    ],
    updates: [
      CampaignUpdate(
        'Book drive launched',
        '3 days ago',
        'Families have already donated more than 700 children’s books.',
        emoji: '📚',
      ),
    ],
  );
  static const communityKitchen = CampaignData(
    id: 'community-kitchen',
    title: 'Build a community kitchen',
    category: 'Community Dev.',
    categoryKey: 'Community',
    amount: '\$11,800',
    goal: '\$22,000',
    progress: .54,
    location: 'Accra, Ghana',
    icon: '🍲',
    gradient: LinearGradient(colors: [Color(0xFF8E5EE9), Color(0xFF4B6EF5)]),
    donors: 202,
    daysLeft: 28,
    fundraiser: 'Akosua Boateng',
    story:
        'A shared kitchen will provide cooking space, nutrition classes, and affordable meals for families in the neighbourhood.',
    milestones: [
      CampaignMilestone('Kitchen design', 'Aug 18 · \$7,000', completed: true),
      CampaignMilestone('Equipment installed', 'Oct 18 · \$22,000'),
    ],
    updates: [
      CampaignUpdate(
        'Local chefs join in',
        '1 week ago',
        'Five chefs have volunteered to lead the first nutrition workshops.',
        emoji: '🍲',
      ),
    ],
  );
  static const waterFilters = CampaignData(
    id: 'water-filters',
    title: 'Water filters for village clinics',
    category: 'Water & Sanitation',
    categoryKey: 'Water',
    amount: '\$7,900',
    goal: '\$12,000',
    progress: .66,
    location: 'Arusha, Tanzania',
    icon: '🚰',
    gradient: LinearGradient(colors: [Color(0xFF00ACC1), Color(0xFF1565C0)]),
    donors: 119,
    daysLeft: 14,
    fundraiser: 'Clean Health Africa',
    organisation: true,
    story:
        'Reliable water filters will protect patients and staff at village clinics from waterborne illness.',
    milestones: [
      CampaignMilestone('Filters ordered', 'Aug 21 · \$6,000', completed: true),
      CampaignMilestone('Clinic installation', 'Sep 28 · \$12,000'),
    ],
    updates: [
      CampaignUpdate(
        'First clinic fitted',
        'Yesterday',
        'The first clinic now has safe drinking water for every patient.',
        emoji: '🚰',
      ),
    ],
  );
  static const coastRecovery = CampaignData(
    id: 'coast-recovery',
    title: 'Restore homes after coastal flooding',
    category: 'Crisis Support',
    categoryKey: 'Crisis',
    amount: '\$17,500',
    goal: '\$30,000',
    progress: .58,
    location: 'Mombasa, Kenya',
    icon: '🏠',
    gradient: LinearGradient(colors: [Color(0xFFF4511E), Color(0xFF8D3A14)]),
    donors: 265,
    daysLeft: 20,
    fundraiser: 'Coast Recovery Network',
    organisation: true,
    story:
        'Families displaced by flooding need building materials, temporary accommodation, and help returning safely home.',
    milestones: [
      CampaignMilestone(
        'Emergency accommodation',
        'Aug 22 · \$15,000',
        completed: true,
      ),
      CampaignMilestone('Home repair grants', 'Oct 10 · \$30,000'),
    ],
    updates: [
      CampaignUpdate(
        'Repair grants issued',
        '4 days ago',
        'The first thirty families have received repair grants.',
        emoji: '🏠',
      ),
    ],
  );

  static const all = [
    communityCentre,
    leahTreatment,
    ruralSchool,
    turkanaWells,
    moroccoRelief,
    foodParcels,
    urbanTrees,
    maternalCare,
    libraryBus,
    communityKitchen,
    waterFilters,
    coastRecovery,
  ];
  static const featured = [communityCentre, leahTreatment, turkanaWells];
  static const trending = [
    communityCentre,
    ruralSchool,
    turkanaWells,
    moroccoRelief,
  ];
  static const recent = [
    foodParcels,
    urbanTrees,
    maternalCare,
    libraryBus,
    communityKitchen,
    waterFilters,
    coastRecovery,
  ];

  static List<CampaignData> forCategory(CampaignCategory category) =>
      all.where((campaign) => campaign.categoryKey == category.name).toList();
}
