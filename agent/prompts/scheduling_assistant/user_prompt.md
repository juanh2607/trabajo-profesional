## **Conversation History (context)**
{{ $('Format Conversation').first().json.transcript }}

## **Last Message**
{{ $('Format Conversation').first().json.lastMessage }}

## Orchestrator Message
{{ $fromAI('key_context', 'Include only current_conversation_stage, key_information (optional) and lead_last_message', 'json') }}

<appointment_information>
{{ $('Format Appointment Information For Agent').first().json.currentAppointments }}
</appointment_information>