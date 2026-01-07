
# Multimodal Content Generation with Gemini on Vertex AI





```bash

import vertexai
import urllib.request
from vertexai.generative_models import GenerativeModel, Part

PROJECT_ID = "your-project-id"
LOCATION = "your-location"

vertexai.init(project=PROJECT_ID, location=LOCATION)

def load_image_from_url(prompt):
    print(f"Processing prompt: {prompt}")
    image_url = "https://storage.googleapis.com/cloud-samples-data/generative-ai/image/scones.jpg"
    
    try:
        with urllib.request.urlopen(image_url) as response:
            image_bytes = response.read()
            
        image_part = Part.from_data(
            data=image_bytes,
            mime_type="image/jpeg"
        )
        model = GenerativeModel("gemini-2.0-flash")

        response = model.generate_content(
            [image_part, prompt],
            generation_config={
                "temperature": 0.4,
                "max_output_tokens": 2048
            }
        )
        
        print("\n--- Model Response ---")
        print(response.text)
        return response.text

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    text_prompt = "Write a descriptive caption for this image and suggest a flavor profile."
    load_image_from_url(text_prompt)
```




