# Call-Center Agent Architecture Analysis

The Dr. Jones call-center agent uses an orchestrator-driven architecture implemented in n8n with a primary orchestrator managing 4 specialized sub-agents as tools.

### Objective

To convert call-center leads into scheduled consultations (first ROFs) while providing a genuine, personalized experience and advancing through the ARC Triangle framework.

Only works with leads that never had an appointment before.

**ARC Triangle Framework**

- **A**ffinity: Building connection and rapport
- **R**eality: Acknowledging the customer's truth and perspective
- **C**ommunication: Establishing two-way dialogue
- **Goal**: Progress through stages to identify the customer's "ruin" (core problem)

**Ruin Identification Progression**

- **Phase 1**: Surface problem recognition ("I want to lose weight")
- **Phase 2**: Deeper exploration ("What would be different if you lost that weight?")
- **Phase 3**: Emotional discovery ("I'm scared I'll get diabetes like my mom")
- **Phase 4**: Solution transition (stop probing, start offering hope)

---

# Core Components

## **1. Orchestrator Agent**

This is the primary coordinator that analyzes incoming messages and delegates to the appropiate sub-agents.

It’s needed because of the complexity of these kinds of conversations (emotional intelligence + medical expertise + business knowledge + scheduling logistics), which a single agent wouldn’t be able to handle effectively.

**Workflow**:

1. Message Analysis (emotional state)
2. Lead Classification (source identification, international, etc)
3. Agent Delegation Strategy
4. Response Synthesis & Quality Check: integrate the responses into a single, coherent one among other quality checks

### When to push for appointment?

Uses a red, yellow, green light approach with patterns to identify and script examples on how to move forward.

**Some Rules:**

- **Skip ruin identification entirely when lead shows commitment signals** - do not force the ARC process if they're already ready to move forward with scheduling or taking action.

- **Stop Deepening When:**
    - Lead provides emotional specifics ("I can't keep up with my kids", "I'm afraid of diabetes")
    - Lead shows solution readiness ("What can you do to help?", "How do I start?")
    - Lead becomes defensive or frustrated with questions
    - 3+ rounds of ARC without new emotional depth revealed
    - Lead explicitly states their main concern/fear/goal
    - Commitment signals detected - any form of agreement to move forward, meet, or take action ("I want to get off completely")

### **Agent Delegation Decision**

The `Engagement Agent` must be involved in **virtually every response**, either as primary agent or in combination with other specialists.

Only exceptions are purely administrative messages (like appointment confirmations).

**Engagement Agent only:**

- Initial conversations with general health/weight loss interest
- Pure emotional support needs (frustration, anxiety, hopelessness)
- Ruin identification and deepening conversations
- When no specific medical, business, or scheduling questions are present

**Expert Agent only (rare):**

- Specific medical/clinical questions about peptides, GLP-1s, dosing
- Direct FLOA protocol inquiries
- Side effects, drug interactions, safety concerns
- Never for general weight loss interest or initial conversations (this is to avoid conflicting with the engagement agent)

**Business Agent only (rare):**

- Pure pricing or policy questions with no emotional content
- Administrative billing/payment issues

**Scheduling Agent only:**

- When scheduling is requested or time zone was provided
- Pure appointment logistics without personal questions
- Cancellation/rescheduling requests
- **Rule**: when scheduling is the focus, don't mix with engagement/rapport building

**Engagement + Expert (very common):**

For medical questions with emotional content

Example: "I'm worried about side effects on semaglutide"

- **Instruction**: start with engagement tone, weave in expert information naturally

**Engagement + Business (very common):**

For pricing questions or program inquiries that need relationship building

**Engagement + Scheduling:**

Scenarios like an appointment re-scheduled because of a personal issue.

- **Instruction**: first acknowledge the issue, then offer alternatives.

**Expert + Business:**

Medical product questions with pricing components

### **Decision Logic Hierarchy:**

1. Always consider Engagement first (mandatory rule)
2. Identify specific expertise needs (medical, business, scheduling)
3. Combine agents when multiple domains are involved
4. Prioritize scheduling when time zone or booking is mentioned
5. Synthesize responses to feel like one cohesive conversation
6. If unknown terms are mentioned, always delegate to both the Expert and the Business agent to see if they understand it (before making any assumption).

---

## **2. Expert Agent**

The clinical and medical guidance specialist with access to Dr. Jones's brain through `dr_jones_brain` tool (which is of mandatory usage).

**Scope**: GLP-1 protocols, FLOA methodology, peptide therapies, side effects, dosing.

It also has access to the product catalog (in case it needs to propose alternatives).

---

## **3. Engagement Agent**

With focus on:

- Detect sentiment/emotion
- Mirror lead tone
- Advance "ARC -> Ruin" gently
- Build trust

### **a. Emotional State Recognition & Response Strategies**

**Frustration Scenarios** (detect: "tried everything," "nothing works," complaints)

- **How handled**: Immediate validation + effort acknowledgment + understanding
- **Why this approach**: Frustrated customers need to feel heard before they'll listen to solutions
- **Example response**: "That must be incredibly frustrating - you've been working so hard at this"

**Fear/Anxiety Scenarios** (detect: "worried," "scared," "is this safe," "side effects")

- **How handled**: Reassurance + transparency offer + normalization
- **Why this approach**: Anxious customers need safety and information to feel secure
- **Example response**: "Those are really smart questions to ask - let me get you clear information"

**Hopelessness Scenarios** (detect: "given up," "nothing helps," "desperate")

- **How handled**: Gentle hope + strength celebration + new perspective offer
- **Why this approach**: Defeated customers need renewed possibility without overwhelming promises
- **Example response**: "The fact that you're here shows incredible strength"

**Excitement/Hope Scenarios** (detect: "excited," "ready to start," "finally found")

- **How handled**: Energy matching + momentum building + forward guidance
- **Why this approach**: Enthusiastic customers need their energy channeled toward action
- **Example response**: "I love your enthusiasm! Let's channel that energy into getting you results"

### **b. Communication Style Adaptation**

- **Formal/Conservative Leads**: Professional tone, no emojis, proper grammar
- **Casual/Emotional Leads**: Mirror emoji usage, informal language, conversational tone
- **Brief/Busy Leads**: Concise responses, direct approach, respect time constraints

---

## **4. Business Agent**

Pricing, financing, shipping and business policy specialist with access to product catalog tools for current offerings and availability (and any future document with business information like available programs, stack/combos, etc)

### **a. Pricing Inquiry Scenarios**

**Initial Price Questions**

- **Scenario**: "How much does this cost?"
- **How handled**: Value-focused deflection + consultation redirect
- **Script**: "The investment depends on which program would work best for your specific situation. Our specialists will go over all options transparently during your free consultation."
- **Why this approach**: Establishes program customization and moves toward value discussion

**Persistent Price Questions**

- **Scenario**: Customer keeps pushing for specific numbers
- **How handled**: Range acknowledgment + financing emphasis + consultation redirect
- **Script**: "Programs range from affordable monthly options to comprehensive packages. We also have financing through Affirm and Klarna. The consultation is free and no-pressure."
- **Why this approach**: Provides some satisfaction while emphasizing accessibility

**Cost Concerns/Budget Objections**

- **Scenario**: "That sounds expensive" or "I'm not sure I can afford it"
- **How handled**: Empathy + financing options + surprise factor
- **Script**: "I hear you - health investments are important decisions. We have multiple payment options including financing and private lenders. Many patients are surprised how accessible it is."
- **Why this approach**: Validates concerns while opening financing conversation

**Comparison Shopping**

- **Scenario**: "How do you compare to [competitor]?" or "I can get Ozempic cheaper"
- **How handled**: Value differentiation + unique positioning
- **Script**: "Rather than comparing prices, I'd encourage you to compare value - we're the only program addressing root causes while using GLP-1s and peptides."
- **Why this approach**: Shifts conversation from price to value proposition

### **b. Insurance & Payment Scenarios**

**Insurance Coverage Questions**

- **Scenario**: "Does insurance cover this?"
- **How handled**: Direct honesty + alternative pathway + HSA option
- **Response Framework**:
    - Primary: "Unfortunately, insurance doesn't cover our compounded medications or services. These are compounded GLP-1s from a 503A pharmacy, and insurance only covers brand name drugs."
    - Alternative: "If your insurance covers brand name medications like Ozempic through your doctor, you can get those covered and work with us just for coaching support."
    - HSA/FSA: "Many patients use HSA/FSA cards for our services."

**Financing Options Inquiries**

- **Scenario**: "What payment options do you have?"
- **How handled**: Comprehensive financing presentation via business tools
- **Options presented**: Affirm, Klarna, PayPal, private lenders, HSA/FSA

### **c. Program & Guarantee Scenarios**

**Weight Loss Guarantee (Warrior Program)**

- **Scenario**: "Do you guarantee results?"
- **How handled**: Specific guarantee details + risk reversal
- **Script**: "With our Warrior coaching program, we guarantee you'll lose at least 1% of your body weight per week. If not, we continue coaching you at no additional cost until you do."

**Lifetime Support (Warrior Program)**

- **Scenario**: "What if I regain weight later?"
- **How handled**: Long-term value proposition + risk elimination
- **Script**: "Even if you regain weight later - 6 months, a year, even 5 years from now - we'll coach you again at no extra charge."

**Medical Approval Guarantee**

- **Scenario**: "What if I'm not approved medically?"
- **How handled**: Statistics + full refund assurance
- **Script**: "95% of our patients are medically approved. If you're in the 5% who aren't approved for medical reasons, you get a full refund of any payment made. Zero risk to get started."

---

## **5. Scheduling Agent**

With access to available time-slots, used for scheduling on ROFs calendars

- Scheduling
- Confirmation
- Cancel/Re-scheduling

With focus on time zone management and availability coordination.

### Calendars

- **Weight Loss ROF** (most common): GLP-1s, metabolic issues, general weight management
- **BHRT ROF**: Hormone replacement therapy, menopause, testosterone issues
- **Blood Panel ROF**: Lab work, health panels, diagnostic testing
- **Healing Peptides ROF**: Injury recovery, therapeutic applications
- **Cognitive Peptides ROF**: Brain health, memory, focus enhancement
- **Growth Hormone ROF**: Anti-aging, muscle building, recovery

### **Workflow**

1. **ROF Calendar Selection** (internal)
    - Analyze customer's primary health goal/interest
    - Map to appropriate specialist calendar (Weight Loss, BHRT, Blood Panel, Healing Peptides, Cognitive Peptides, Growth Hormone)
    - Never reveal internal calendar system to customer
2. **Information Gathering**
    - Collect time zone (mandatory before checking availability)
    - Gather any scheduling preferences or constraints
    - Confirm contact information accuracy
3. **Availability Management** (Tool-based)
    - Present one optimal option initially, then 2-3 more if requested
    - Display times in customer's time zone
    - Account for appointment duration and type
4. **Booking Confirmation** (Multi-step process)
    - Confirm all details with double time zone verification
    - Use Book Appointment tool with correct ROF calendar ID

**International Leads Special Handling**

Offer coaching only because of legal/regulatory restrictions on international medical consultations

### **Cancellation vs Rescheduling Logic**

**Ambiguous Intent Scenarios**

- **Scenario**: "I can't make my appointment"
- **How handled**: Offer rescheduling first, not cancellation
- **Script**: "I understand you can't make your current appointment. Would you like me to find you a new time that works better?"

**Rescheduling Workflow (Delete + Book Process)**

1. Use Delete Appointment tool to cancel current slot
2. Check new availability and offer options
3. Confirm new time and use Book Appointment tool
4. Provide new confirmation details