import os
import numpy as np
import shutil
import random
root_dir = '/scratch1/07980/sli4/images'

test_ratio = 0.10
val_ratio = 0.10

os.makedirs(root_dir +'train/',exist_ok=True)
os.makedirs(root_dir +'test/' ,exist_ok=True)
os.makedirs(root_dir +'val/',exist_ok=True)

src = root_dir 

allFileNames = os.listdir(src)
np.random.shuffle(allFileNames)
train_FileNames, test_FileNames, val_FileNames = np.split(np.array(allFileNames),
                                                          [int(len(allFileNames)* (1 - test_ratio- val_ratio)), 
                                                          int(len(allFileNames)*(1-val_ratio))])


train_FileNames = [src+'/'+ name for name in train_FileNames.tolist()]
test_FileNames = [src+'/' + name for name in test_FileNames.tolist()]
val_FileNames = [src+'/' + name for name in val_FileNames.tolist()]

print("*****************************")
print('Total images: ', len(allFileNames))
print('Training: ', len(train_FileNames))
print('Testing: ', len(test_FileNames))
print('Validation: ', len(val_FileNames))
print("*****************************")



for name in train_FileNames:
    shutil.copy(name, root_dir +'train/')

for name in test_FileNames:
    shutil.copy(name, root_dir +'test/')

for name in val_FileNames:
    shutil.copy(name, root_dir +'val/')
print("Copying Done!")
