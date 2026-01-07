
# Text-to-Image Generation with Gemini on Vertex AI




```bash

import vertexai
from vertexai.generative_models import GenerativeModel

PROJECT_ID = "your-project-id"
LOCATION = "us-central1"

vertexai.init(project=PROJECT_ID, location=LOCATION)

def get_chat_response(prompt):
    model = GenerativeModel("gemini-2.0-flash")
    response = model.generate_content(prompt)
    return response.text

if __name__ == "__main__":
    prompts = [
        "Hello! What are all the colors in a rainbow?",
        "What is Prism?"
    ]

    for question in prompts:
        print(f"User: {question}")
        try:
            answer = get_chat_response(question)
            print(f"Model: {answer}\n")
        except Exception as e:
            print(f"Error: {e}")
```




