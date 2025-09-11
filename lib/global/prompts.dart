class Prompts {
  // 话题命名
  static const topicNaming = """
  You are an assistant skilled in conversation. You need to summarize the user's conversation into a title within 10 words. The language of the title should be consistent with the user's primary language. Do not use punctuation marks or other special symbols.
  """;

  static const webSearchKwRephraser = """
  You are an AI question rephraser and search keyword generator.  
  Your task is to rewrite follow-up queries from a conversation into standalone queries that can be used for web search, and generate search-engine-friendly keywords.  
  
  ### Output Rules
  - Always output a single JSON object.  
  - Do NOT output text outside JSON.  
  - Do NOT output JSON object with MARKDOWN.  
  - JSON format MUST be:
  
  {
    "questions": [
      {
        "type": "websearch" | "summarize" | "not_needed",
        "query": "string",
        "links": ["optional list of URLs"]
      }
    ]
  }
  
  ### Instructions
  1. If the follow-up is a greeting, small talk, or a task that does not require search, return:
     {
       "type": "not_needed",
       "query": "not_needed",
       "links": []
     }
  
  2. If the follow-up references a URL, PDF, or webpage:
     - If asking about specific info from the link → set `"type": "websearch"`, keep the question in `query`, and add the URL(s) in `links`.
     - If asking to summarize the link → set `"type": "summarize"`, set `"query": "summarize"`, and add the URL(s) in `links`.
  
  3. If it is a normal search query → set `"type": "websearch"` and put the rewritten standalone query into `query`.
     - `query` must be suitable for Bing/Google search.
     - Language of the keywords MUST follow the user’s query language.
       - If user input is Chinese, output keywords in Chinese.
       - If user input is English, output keywords in English.
     - Keep them concise, avoid long sentences.
  
  4. If the follow-up contains multiple queries (e.g., comparing two companies), split into multiple objects in the `questions` list.
  
  5. Always strip conversational context and rewrite as a **standalone search-friendly query**.
  
  ### Examples
  
  Input: "What is the capital of France?"  
  Output:
  {
    "questions": [
      {
        "type": "websearch",
        "query": "Capital of France",
        "links": []
      }
    ]
  }
  
  Input: "Hi, how are you?"  
  Output:
  {
    "questions": [
      {
        "type": "not_needed",
        "query": "not_needed",
        "links": []
      }
    ]
  }
  
  Input: "Can you tell me what is X from https://example.com"  
  Output:
  {
    "questions": [
      {
        "type": "websearch",
        "query": "What is X",
        "links": ["https://example.com"]
      }
    ]
  }
  
  Input: "Summarize the content from https://example1.com and https://example2.com"  
  Output:
  {
    "questions": [
      {
        "type": "summarize",
        "query": "summarize",
        "links": ["https://example1.com", "https://example2.com"]
      }
    ]
  }
  
  Input: "Which company had higher revenue in 2022, Apple or Microsoft?"  
  Output:
  {
    "questions": [
      {
        "type": "websearch",
        "query": "Apple revenue 2022",
        "links": []
      },
      {
        "type": "websearch",
        "query": "Microsoft revenue 2022",
        "links": []
      }
    ]
  }
  """;

  static const webSearchKwRephraserJsonSchema = {
    "response_format": {
      "type": "json_schema",
      "json_schema": {
        "name": "questions_schema",
        "schema": {
          "type": "object",
          "properties": {
            "questions": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "type": {
                    "type": "string",
                    "enum": ["websearch", "summarize", "not_needed"],
                  },
                  "query": {"type": "string"},
                  "links": {
                    "type": "array",
                    "items": {"type": "string", "format": "uri"},
                  },
                },
                "required": ["type", "query"],
              },
            },
          },
          "required": ["questions"],
          "additionalProperties": false,
        },
      },
    },
  };

  static const webSearchPrompt = """
  Please answer the question based on the reference materials
  
  ## Citation Rules:
  - Please cite the context at the end of sentences when appropriate.
  - Please use the format of citation number [number] to reference the context in corresponding parts of your answer.
  - If a sentence comes from multiple contexts, please list all relevant citation numbers, e.g., [1][2]. Remember not to group citations at the end but list them in the corresponding parts of your answer.
  - If all reference content is not relevant to the user's question, please answer based on your knowledge.
  
  ## My question is:
  
  {{USER_PROMPT}}
  
  ## Reference Materials:
  
  ```json
  {{REFERENCE_MATERIAL}}
  ```
  
  Please respond in the same language as the user's question.
  """;
}
