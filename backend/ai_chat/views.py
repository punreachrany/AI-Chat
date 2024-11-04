# ai_chat/views.py

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny  # Change to IsAuthenticated if needed
import ollama  # Ensure you have this installed
class ChatView(APIView):
    permission_classes = [AllowAny]  # Change to IsAuthenticated if you require authentication

    def post(self, request):
        user_message = request.data.get('message')

        try:
            # print("HERE")
            # Call the LLaMA model with the user's message
            stream = ollama.chat(
                model='llama3.2',  # Use the appropriate model name
                messages=[{'role': 'user', 'content': user_message + " Reply like human"}],
                stream=True,
            )


            # Capture the response from the model
            response_message = ''
            for chunk in stream:
                print(chunk)
                response_message += chunk['message']['content']

            return Response({'response': response_message})

        except Exception as e:
            return Response({'error': str(e)}, status=500)
