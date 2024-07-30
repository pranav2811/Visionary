#python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from transformers import BlipProcessor, BlipForConditionalGeneration
from PIL import Image
import torch
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)

app = FastAPI()

# Load the BLIP model and processor
processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")

@app.get("/")
async def read_root():
    return {"message": "Welcome to the FastAPI server!"}

@app.get("/test")
async def test_endpoint():
    logging.info("Test endpoint called.")
    return {"message": "Test successful"}

@app.post("/describe_image")
async def describe_image(file: UploadFile = File(...)):
    logging.info("Received request for image description.")
    try:
        image = Image.open(file.file)
        logging.info("Image loaded successfully.")
        inputs = processor(images=image, return_tensors="pt")
        logging.info("Image processed successfully.")

        out = model.generate(**inputs)
        description = processor.decode(out[0], skip_special_tokens=True)
        logging.info(f"Generated description: {description}")

        return JSONResponse(content={"description": description})
    except Exception as e:
        logging.error(f"Error processing image: {e}")
        return JSONResponse(content={"error": str(e)}, status_code=500)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
