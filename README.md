# Carbon Footprint Calculator

## Setup information
Ensure localhost on MySQL is running. Replace user credentials in app.py with respective credentials.
Additionally ensure that you have required libraries in app.py installed. 

## Relational Schema

### Chen Diagram
<img src="erdiag.svg" alt="Schema" width="800" height="600" />

### User
- **user_id** (PK)
- name
- email
- address
- street
- city
- state

### Organisation
- **org_id** (PK)
- org_name

### Region
- **Region_ID** (PK)
- Region_name
- grid_type
- country

### Activity
- **activity_id** (PK)
- act_name
- act_type
- date
- quantity

### Emission_factor
- **factor_id** (PK)
- activity_type
- unit
- factor_value
- Region_ID (FK → Region)

### CarbonFootprint
- **cfp_id** (PK)
- emission_val
- calc_date
- activity_id (FK → Activity)
- factor_id (FK → Emission_factor)

### Recommendation
- **rec_id** (PK)
- suggestion_text
- activity_id (FK → Activity)

### BelongsTo (User-Region)
- **user_id** (PK, FK → User)
- **Region_ID** (PK, FK → Region)

### Logs (User-Activity)
- **user_id** (PK, FK → User)
- **activity_id** (PK, FK → Activity)

### member_of (User-Organisation)
- **user_id** (PK, FK → User)
- **org_id** (PK, FK → Organisation)

---

### Relationships
- A **User** can belong to multiple **Regions** (M:N via BelongsTo)
- A **User** logs multiple **Activities** (M:N via Logs)
- A **User** is a member of one **Organisation** (M:1 via member_of)
- A **Region** has multiple **Emission_factors** (N:1)
- An **Activity** applies to one **Emission_factor** (M:1)
- An **Activity** calculates one **CarbonFootprint** (M:1)
- An **Activity** generates one **Recommendation** (M:1)

## Implementation details
- File `app.py` contains logic for `mysql-connector` and routing of HTML pages from local Flask server.
- Directory `templates` contains the webpages.
- Files `create_db.sql` and `functions_triggers.sql` contain database creation process and data retrieval/updation logic respectively.
- `erdiag.svg` is the Chen diagram for the relational schema that we have devised for the project.
- Directory `static` contains the JS files for handling the form logic from the HTML pages to the Python file.


