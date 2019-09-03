# VMM 2016 Cookbook Source Code
This is the code repository for [System Center 2016 Virtual Machine Manager Cookbook - Third Edition](https://www.packtpub.com/virtualization-and-cloud/system-center-2016-virtual-machine-manager-cookbook-third-edition?utm_source=github&utm_medium=repository&utm_campaign=9781785881480), written by me and published by [Packt](https://www.packtpub.com/?utm_source=github). It contains all the supporting project files necessary to work through the book from start to finish.

## About the Book
Virtual Machine Manager (VMM) 2016 is part of the System Center suite to configure and manage datacenters and offers a unified management experience on-premises and Azure cloud.

This book will be your best companion for day-to-day virtualization needs within your organization, as it takes you through a series of recipes to simplify and plan a highly scalable and available virtual infrastructure. You will learn the deployment tips, techniques, and solutions designed to show users how to improve VMM 2016 in a real-world scenario. The chapters are divided in a way that will allow you to implement the VMM 2016 and additional solutions required to effectively manage and monitor your fabrics and clouds. We will cover the most important new features in VMM 2016 across networking, storage, and compute, including brand new Guarded Fabric, Shielded VMs and Storage Spaces Direct. The recipes in the book provide step-by-step instructions giving you the simplest way to dive into VMM fabric concepts, private cloud, and integration with external solutions such as VMware, Operations Manager, and the Windows Azure Pack.

By the end of this book, you will be armed with the knowledge you require to start designing and implementing virtual infrastructures in VMM 2016.

## Instructions and Navigation
All of the code is organized into folders. Each folder starts with a number followed by the application name. For example, Chapter02.



The code will look like the following:
```
    Test-Cluster -Node w2k16lib01, w2k16lib02
    New-Cluster -Name vmmLibHA -Node w2k16lib01, w2k16lib02
```
