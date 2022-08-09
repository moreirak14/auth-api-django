from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import CreateUserSerializer, UserSerializer


class RegisterView(APIView):
    def post(self, request):
        data = request.data
        serializer = CreateUserSerializer(data=data)

        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        user = serializer.create(serializer.validated_data)
        user = UserSerializer(user)

        return Response(data=user.data, status=status.HTTP_201_CREATED)
