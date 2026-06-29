import { LightningElement } from 'lwc';
export default class MyCV extends LightningElement {
    name = "Rita Nassar";
    professional_summary = "A Computer Science graduate from the Lebanese University, currently preparing to begin my Master’s degree. I have a strong foundation in programming, software engineering, and web development. I am highly motivated, quick to learn, and passionate about building technology that solves real-world problems. I aim to contribute meaningfully to development teams and grow professionally in the tech industry.";
    technical_skills = ['C++', 'Angular', 'TypeScript', 'RecurrenceActivity', 'Salesforce'];
     experiences = [
        {
            id: 'exp1',
            title: 'AI Engineer Intern',
            company: 'inmind.ai',
            location: 'Mkalles',
            date: '04/2025 - 07/2025',
            description: 'Gained comprehensive hands-on experience in Angular, mastering its core concepts, components, services, and state management throughout the internship.'
        },
        {
            id: 'exp2',
            title: 'Summer School Staff',
            company: 'Bric-A-Brac',
            location: 'Nahr el Mot',
            date: '07/2024 - 09/2024',
            description: 'I honed my organizational and problem-solving abilities while efficiently managing activities and collaborating with staff.'
        },
        {
            id: 'exp3',
            title: 'Cashier',
            company: 'Khawli Supermarket',
            location: 'Sabtieh',
            date: '07/2022 - 11/2022',
            description: 'Enhanced customer service and problem-solving skills, ensured precise data handling, and fostered teamwork.'
        }
    ];
    languages = ['English', 'Arabe', 'French'];
    certifications = ['CCNA1'];
    education="Master 1 Computer Science In The Lebanese Univerity Fanar";
}