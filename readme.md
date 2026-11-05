awx-playbooks/
│
├── ansible.cfg
├── requirements.yml
│
├── inventories/
│   └── production/
│       └── inventory.yml
│
├── group_vars/
│   ├── ubuntu_2204.yml
│   └── ubuntu_2404.yml
│
├── playbooks/
│   ├── cis_audit.yml
│   ├── cis_audit_2204.yml
│   ├── cis_audit_2404.yml
│   ├── cis_report.yml
│   └── cis_remediation.yml
│
├── roles/
│   └── cis_audit/
│       ├── defaults/
│       │   └── main.yml
│       ├── tasks/
│       │   ├── main.yml
│       │   ├── collect_facts.yml
│       │   ├── execute_controls.yml
│       │   └── generate_report.yml
│       └── templates/
│           └── report.json.j2
│
├── controls/
│   ├── common/
│   │   ├── ssh/
│   │   ├── filesystem/
│   │   └── logging/
│   │
│   ├── ubuntu2204/
│   │   ├── section_1.yml
│   │   ├── section_2.yml
│   │   ├── section_3.yml
│   │   ├── section_4.yml
│   │   ├── section_5.yml
│   │   └── section_6.yml
│   │
│   └── ubuntu2404/
│       ├── section_1.yml
│       ├── section_2.yml
│       ├── section_3.yml
│       ├── section_4.yml
│       ├── section_5.yml
│       └── section_6.yml
│
└── reports/
