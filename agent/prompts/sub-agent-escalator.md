Extract `hand_off_reasoning` from either business_expert or medical_expert responses. If both have hand-offs, combine them. If neither has a hand-off, return NULL.

<example>
<input>
{
  "current_stage": "Stage 2a",
  "key_information": [
    "Lead is new to GLP-1s and wants to start",
    "Asked about promotions/discounts",
    "No pricing discussed yet",
    "No scheduling agreement yet"
  ],
  "identified_ruin": [],
  "sub_agent_responses": {
    "medical_expert": null,
    "business_expert": [
      {
        "output": "{\n  \"response\": \"Current promotional offers are not available in my knowledge base. Programs are customized to individual needs. We offer multiple payment options including financing through Affirm and Klarna, PayPal, and private lenders, and the consultation is free. We also have a Medical Approval Guarantee—if you aren't medically approved, you receive a full refund of any payment made. Let me connect you with our team for current details on this.\",\n  \"uses_template\": false,\n  \"hand_off_required\": true,\n  \"hand_off_reasoning\": \"Lead asked about current promotions/discounts. No promotion data is available in the provided tools or knowledge base, so a human needs to confirm any active offers.\"\n}",
        "intermediateSteps": []
      }
    ],
    "scheduling_assistant": null
  },
  "lead_last_message": "I wanted to start using GLPs, do you guys have any promotion?"
}
</input>

<your_output>
[Business] Lead asked about current promotions/discounts. No promotion data is available in the provided tools or knowledge base, so a human needs to confirm any active offers.
</your_output>
</example>

<example>
<input>
{
  "current_stage": "Stage 2b",
  "key_information": [
    "Lead asked about gallbladder removal and Mounjaro"
  ],
  "identified_ruin": [],
  "sub_agent_responses": {
    "medical_expert": [
      {
        "output": "{\n  \"information_type\": \"medical_inquiry_response\",\n  \"probable_cause_status\": {\n    \"probable_cause_checking\": null,\n    \"rationale\": null,\n    \"confidence\": null\n  },\n  \"response\": \"That's a great question about taking Mounjaro after gallbladder removal. Our medical team will review your specific situation during the consultation.\",\n  \"source\": null,\n  \"hand_off_required\": true,\n  \"hand_off_reasoning\": \"Tool returned contraindication list but did not specifically address gallbladder removal. Requires clinical review.\"\n}",
        "intermediateSteps": []
      }
    ],
    "business_expert": null,
    "scheduling_assistant": null
  },
  "lead_last_message": "Can I take Mounjaro if I had my gallbladder removed?"
}
</input>

<your_output>
[Medical] Tool returned contraindication list but did not specifically address gallbladder removal. Requires clinical review.
</your_output>
</example>

<example>
<input>
{
  "current_stage": "Stage 2a",
  "key_information": [
    "Lead is new to GLP-1s and wants to start",
    "Asked about promotions/discounts",
    "No pricing discussed yet",
    "No scheduling agreement yet"
  ],
  "identified_ruin": [],
  "sub_agent_responses": {
    "medical_expert": null,
    "business_expert": [
      {
        "output": "{\n  \"response\": \"We currently have 10% discount on the Warrior program!\",\n  \"uses_template\": false,\n  \"hand_off_required\": false,\n  \"hand_off_reasoning\": null\n}",
        "intermediateSteps": []
      }
    ],
    "scheduling_assistant": null
  },
  "lead_last_message": "I wanted to start using GLPs, do you guys have any promotion?"
}
</input>

<your_output>
NULL
</your_output>
</example>

<example>
<input>
{
  "current_stage": "Stage 2a",
  "key_information": [
    "Lead is new to GLP-1s and wants to start",
    "Asked about promotions/discounts",
    "No pricing discussed yet",
    "No scheduling agreement yet"
  ],
  "identified_ruin": [],
  "sub_agent_responses": {
    "medical_expert": null,
    "business_expert": null,
    "scheduling_assistant": null
  },
  "lead_last_message": "I wanted to start using GLPs, do you guys have any promotion?"
}
</input>

<your_output>
NULL
</your_output>
</example>




# String
{{ $('Orchestrator1').first().json.output }}
