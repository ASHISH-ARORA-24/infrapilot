from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required


def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('dashboard')
        return render(request, 'dashboard/login.html', {'error': 'Invalid credentials'})
    return render(request, 'dashboard/login.html')


@login_required(login_url='login')
def dashboard_view(request):
    return render(request, 'dashboard/dashboard.html')


def logout_view(request):
    logout(request)
    return redirect('login')
