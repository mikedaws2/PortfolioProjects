#!/usr/bin/env python
# coding: utf-8

# # BMI Calculator

# In[18]:


name = input('Enter your name: ')
weight = int(input('Enter your weight in pounds: '))
height = int(input('Enter your height in inches : '))
bmi = (weight * 703) / (height * height)


# In[20]:


if bmi>0:
    if(bmi<18.5):
        print(name + ", your BMI is " + str(bmi) + " and you are underweight.")
    elif(bmi<=24.9):
        print(name + ", your BMI is " + str(bmi) + " and you are a normal weight.")
    elif(bmi<=29.9):
        print(name + ", your BMI is " + str(bmi) + " and you are overweight.")
    elif(bmi<=34.9):
        print(name + ", your BMI is " + str(bmi) + " and you are obese.")
    elif(bmi<=39.9):
        print(name + ", your BMI is " + str(bmi)+ " and you are severly obese.")
    else:
        print(name + ", your BMI is " + str(bmi) + " and you are morbidly obese.")


# In[ ]:





# In[ ]:





# In[ ]:


#BMI = (weight in pounds x 703) / (height in inches x height in inches)

