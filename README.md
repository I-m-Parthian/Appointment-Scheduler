# Appointment Scheduler
API based application to perfom 4 simple tasks around appointment booking.
The tasks are:
1. Getting a list of available dates and times
2. Choosing an appointment time
3. Canceling an appointment
4. Modifying an appointment

## Get list of available dates and times
* **Assumption**: all the available slots are already populated in the database. For the same we have created a script in **db/seed.rb** to populate database.
* Slots are categories by the status. A slot can have 3 possible value for the Status(**available, booked, canceled**)
* All the slots with status as available will be fetched for this case
* Date and time are in (DD/MM/YYYY HH:MM PM) format
### Request
```http request
GET /appointments
```
### Response
```json
{
  "available_slots": [
    {
      "id": 33,
      "status": "available",
      "date_time": "10/11/2024 06:30PM"
    },
    {
      "id": 36,
      "status": "available",
      "date_time": "11/11/2024 04:30PM"
    },
    {
      "id": 38,
      "status": "available",
      "date_time": "11/11/2024 03:00PM"
    }
  ]
}
```

## Choose an appointment time
* Pass the id of a available slot. If the status of the slot is *available* then change it to *booked*
### Request
```http request
PUT /choose_appointment/1
```
### Reponse(Success)
```json
{
  "message": "Appointment created successfully",
  "appointment": {
    "id": 48,
    "status": "booked",
    "date_time": "12/11/2024 06:30PM"
  }
}
```
### Reponse(Error 1)
```json
{
    "error": {
        "code": "invalid_slot",
        "message": "Given date/time is not available"
    }
}
```

### Reponse(Error 2)
```json
{
  "errors": [
    "Status bookedf is not a valid status"
  ]
}
```
## Cancel an appointment
* To cancel an appointment, change status of an appointment to *canceled*

### Request
```http request
DELETE /appointments/1
```

### Response(Success)
```json
{
    "message": "Appointment canceled successfully.",
    "appointment": {
        "status": "canceled",
        "id": 44,
        "date_time": "08/11/2024 06:30PM"
    }
}
```

### Response(Error)
```json
{
    "error": {
        "code": "cancellation_failed",
        "message": "Unable to cancel the appointment",
        "details": [
            "Status delete is not a valid status"
        ]
    }
}
```
## Modify an Appointment
* Pass the id of the appointment you want to modify along with the new available appointment id
* Swap the status of both the appointment slots (booked <> available)
### Request
```http request
PUT /appointments/1
Content-Type: application/json

{
    "appointment" : {
        "new_appointment_id": 2
    }
}
```
### Response(Success)
```json
{
    "message": "Appointment created successfully",
    "appointment": {
        "id": 38,
        "status": "booked",
        "date_time": "11/11/2024 06:30PM"
    }
}
```

### Response(Error 1)
```json
{
  "error": {
    "code": "unavailable_slot",
    "message": "New date/time is not available"
  }
}
```
### Response(Error 2)
```json
{
  "error": {
    "code": "invalid_slot",
    "message": "Given date/time is not available"
  }
}
```
### Appointment Model
- `id`: Integer, primary key.
- `status`: String, possible values: `available`, `booked`, `canceled`.
- `date_time`: DateTime, formatted as `DD/MM/YYYY HH:MM PM`.

### Summary of the error handling implemented:

* 400 Bad Request: Invalid request parameters.
* 404 Not Found: Resource not found (e.g., appointment ID does not exist).
* 422 Unprocessable Entity: Validation errors (e.g., slot unavailable).
* 500 Internal Server Error: Unexpected server errors.
