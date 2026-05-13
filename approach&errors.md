------------------------------------------------------
1. Understanding the Problem

The goal of this assignment is to build a backend system that can process incoming guest messages from different sources (e.g., WhatsApp), understand their intent, and generate a structured response.

Instead of focusing only on functionality, the problem emphasizes:

Breaking the system into logical components
Handling ambiguity and errors
Writing code that is readable and extendable
-----------------------------------------------------------
2. Approach and System Design

To solve this problem, I designed the system using a modular, layered approach so that each responsibility is clearly separated.

🔹 Key Components:

API Layer (FastAPI)
Accepts incoming requests
Validates input using Pydantic models
Returns structured JSON responses
Normalization Layer
Cleans and standardizes incoming messages
Converts text to lowercase and trims whitespace
Generates a unique UUID for each message
Classification Layer
Determines the intent of the message (e.g., booking inquiry, greeting)
Uses simple rule-based logic for now
Response Generation Layer
Generates a reply based on the detected query type
Can be extended to use LLMs or external APIs
----------------------------------------------------------

3. Design Decisions
a. Why Modular Design?

Breaking the system into separate layers improves:

Readability
Maintainability
Ease of debugging
Future scalability
b. Why Rule-Based Classification?

I chose a rule-based approach because:

It is simple and fast to implement
Works well for clearly defined patterns
Can be easily replaced with an ML/LLM model later
c. Why UUID for Messages?

Each message is assigned a unique ID to:

Track requests easily
Debug issues
Support future database storage
---------------------------------------------------------------

4. Handling Errors and Edge Cases

While testing the API using Swagger, I encountered a 422 Unprocessable Entity error caused by invalid JSON formatting (newline inside a string).

 Resolution:
Identified that JSON does not allow raw line breaks in strings
Fixed by converting the message into a single line or using \n

This helped ensure that the API handles valid input correctly and improved my understanding of strict JSON validation.
--------------------------------------------------------------------

5. Code Readability and Simplicity

I focused on writing code that is:

Easy to understand
Clearly structured
Free from unnecessary complexity

Examples:

Meaningful function names (normalize_message, classify_query)
Separation of logic into different files
Avoided over-engineering
--------------------------------------------------------------

6. Trade-offs
Decision	Trade-off
Rule-based classification	Less flexible than ML models
No database integration	No persistence of messages
Minimal logging	Simpler code, but less observability

These choices were made to prioritize clarity and working functionality within the scope of the assignment.
-------------------------------------------------------------------


7. Scalability and Future Improvements

The system is designed to be easily extendable. Possible improvements include:

Integrating an LLM (e.g., Claude/OpenAI) for smarter responses
Replacing rule-based classification with ML models
Adding a database to store conversations
Implementing authentication and rate limiting
Adding structured logging for monitoring
--------------------------------------------------------------

8. What I Learned
How to structure a backend system in a modular way
Importance of clean and readable code
Handling real-world issues like JSON validation errors
Designing systems that can scale beyond the initial implementation
---------------------------------------------------------------------

9. Conclusion

This implementation focuses on clarity, structure, and correctness rather than complexity. The system successfully processes incoming messages, classifies them, and returns structured responses while remaining easy to understand and extend.
-------------------------------------------------------------------

*** Final Note

The system is intentionally kept simple but is designed in a way that it can evolve into a production-ready solution with minimal changes.