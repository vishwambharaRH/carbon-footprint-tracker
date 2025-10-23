# Carbon Footprint Calculator

## Setup information
XYZ

## Relational Schema

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
cuh ol uhef v

## Additional Information

